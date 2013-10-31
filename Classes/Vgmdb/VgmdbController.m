//
//  VgmdbController.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

#import "VgmdbController.h"
#import "DisplayController.h"
#import "Utility.h"
#import "FileSystemNode.h"
#import "Tags.h"
#import "QuickLookTableView.h"

#import "Vgmdb.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);

static NSArray *dateFormats;
static NSMutableDictionary *dates;


@implementation VgmdbController
@synthesize files, query;

#pragma mark -
#pragma mark GUI Callbacks

- (IBAction)changeDisplayLanguage:(id)sender 
{
    NSButtonCell *selCell = [sender selectedCell];
    DDLogInfo(@"Selected cell is %@", [languages objectAtIndex:[selCell tag]]);
	selectedLanguage = [languages objectAtIndex:[selCell tag]];
	[table setNeedsDisplayInRect:
	 [table rectOfColumn:
	  [table columnWithIdentifier:@"album"]]];
	
}

- (void) makeDates
{
	for (NSDictionary *i in searchResults) {
		NSString *s=  [i valueForKey:@"released"];
//		DDLogVerbose(@"%@",s);
		NSDate *date;
		for (NSDateFormatter *formatter in dateFormats) {
			date = [formatter dateFromString:s];
			if (date) break;
		}
//		DDLogVerbose(@"%@",date);
		[dates setValue:date forKey:s];
	}
}

- (IBAction) searchForAlbums:(id)sender
{
	DDLogInfo(@"Search button pressed");

    id temp = [vgmdb searchResults:query];
	if (temp == [NSNull null]){
		searchResults = nil;
	}else if ([temp isKindOfClass:[NSDictionary class]]) {
		ssc = [[DisplayController alloc] initWithAlbum:temp 
												 vgmdb:vgmdb 
												 files:files];
		[self confirmSheet:nil];
	}else{
		searchResults = temp;
		[self makeDates];
	}
	
	DDLogVerbose(@"result %@", searchResults);
	[table reloadData];
}

- (IBAction) selectAlbum:(id)sender{
	
	ssc = [[DisplayController alloc] 
		   initWithUrl:[[searchResults objectAtIndex:[table selectedRow]] 
						objectForKey:@"url"]
		   vgmdb:vgmdb
		   files:files];
	
	[self confirmSheet:nil];
}

#pragma mark -
#pragma mark Query Setting

- (IBAction) useAlbumForQuery:(id)sender     { self.query = tags.album;   }
- (IBAction) useArtistForQuery:(id)sender    { self.query = tags.artist;  }
- (IBAction) useCommentForQuery:(id)sender   { self.query = tags.comment; }
- (IBAction) useDirectoryForQuery:(id)sender { self.query = directory;    }



#pragma mark -
#pragma mark Table Methods 

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[selectAlbumButton setEnabled:([table selectedRow] != -1 ? YES : NO )];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
    return searchResults ? [searchResults count] : 0;
}

- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	NSString *s= [Utility valueFromResult:
				   [[searchResults objectAtIndex:rowIndex] 
					objectForKey:[aTableColumn identifier]]
						 selectedLanguage:selectedLanguage];
	
	
	return s;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
	NSImage *indicatorImage;
	NSString * identifer = [tableColumn identifier];
	
	if ([currentColumnKey isEqualToString:identifer]){
		currentColumnAscending = !currentColumnAscending;
	}else{
		currentColumnAscending = NO;
		currentColumnKey = identifer;
		for (NSTableColumn *column in [tableView tableColumns]) {
			[tableView setIndicatorImage: nil
						   inTableColumn: column];
		}
	}
	
	[tableView setHighlightedTableColumn:tableColumn];
	short mult = currentColumnAscending ? 1 : -1;
	
	NSArray *temp;
	if ([[tableColumn identifier] isEqualTo:@"released"]){
		temp = [searchResults sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			
			id s1= [Utility valueFromResult:
					[obj1 objectForKey:[tableColumn identifier]]
						   selectedLanguage:selectedLanguage];
			id s2= [Utility valueFromResult:
					[obj2 objectForKey:[tableColumn identifier]]
						   selectedLanguage:selectedLanguage];
			
			NSDate *d1 = [dates valueForKey:s1];
			NSDate *d2 = [dates valueForKey:s2];
			
			return mult * [d1 compare:d2];
		}];
	}else{
		temp =
		[searchResults sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			id s1= [Utility valueFromResult:
					[obj1 objectForKey:[tableColumn identifier]]
						   selectedLanguage:selectedLanguage];
			id s2= [Utility valueFromResult:
					[obj2 objectForKey:[tableColumn identifier]]
						   selectedLanguage:selectedLanguage];
			return mult *[s1 localizedStandardCompare:s2];
		}];
	}
	
	if (currentColumnAscending){
		indicatorImage = [NSImage imageNamed: @"NSAscendingSortIndicator"];		
	}else{
		indicatorImage = [NSImage imageNamed: @"NSDescendingSortIndicator"];	
	}
	
	[tableView setIndicatorImage: indicatorImage
                   inTableColumn: tableColumn];
	searchResults = temp;
	[table reloadData];
}


- (IBAction)onClick:(id)sender
{
	NSInteger row = [table clickedRow];
    ssc = [[DisplayController alloc]
		   initWithUrl:[[searchResults objectAtIndex:row]
						objectForKey:@"url"]
		   vgmdb:vgmdb
		   files:files];
	
	[self confirmSheet:nil];
    
}

#pragma mark - QuickLook

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel;
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    previewPanel = panel;
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    previewPanel = nil;
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
	return searchResults ? [searchResults count] : 0;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel
				previewItemAtIndex:(NSInteger)index
{
//    DDLogVerbose(@"url %@",searchResults[index][@"url"]);
    return [NSURL URLWithString:searchResults[index][@"url"]] ;
}

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)item
{
    SEL action = [item action];
    if (action == @selector(togglePreviewPanel:)) {
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [(NSMenuItem*)item setTitle:@"Close Quick Look panel"];
        } else {
            [(NSMenuItem*)item setTitle:@"Open Quick Look panel"];
        }
        return YES;
    }
    return YES;
}

#pragma mark - Quicklook Delegate
- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event
{
    // redirect all key down events to the table view
    if ([event type] == NSKeyDown) {
        [table keyDown:event];
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark Sheets 

- (void) didEndSheet:(NSWindow*)sheet 
		  returnCode:(int)returnCode
		  mainWindow:(NSWindow*)mainWindow
{	
	DDLogInfo(@"Search End Sheet");
	[sheet orderOut:self];
	
	if (returnCode == NSOKButton){		
		[NSApp beginSheet: [ssc window]
		   modalForWindow: mainWindow
			modalDelegate: ssc 
		   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
			  contextInfo: (__bridge_retained void*) mainTable ]; 		
	}
	
}
- (IBAction)cancelSheet:sender
{	
	DDLogInfo(@"Search Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}



- (IBAction)confirmSheet:sender
{
	DDLogInfo(@"Search Comfirm");
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

#pragma mark -
#pragma mark Init

- (id)initWithFiles:(NSArray*)newFiles
			  table:(NSTableView*)aTable;
{
	self = [super initWithWindowNibName:@"VgmdbSearch"];
    if (self) {
		
		languages = [[NSArray alloc] initWithObjects:@"english", @"romaji",@"kanji" , nil];
		selectedLanguage = [languages objectAtIndex:0];
        
        vgmdb = [Vgmdb new];
        [self reset:newFiles];
		mainTable = aTable;
    }
    return self;
}

+ (void)initialize
{
	NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
	[dateFormat1 setDateFormat:@"LLL dd, yyyy"];
	
	NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
	[dateFormat2 setDateFormat:@"LLL, yyyy"];
	
	NSDateFormatter *dateFormat3 = [[NSDateFormatter alloc] init];
	[dateFormat3 setDateFormat:@"yyyy"];
	dateFormats = [[NSArray alloc] initWithObjects:dateFormat1,dateFormat2, dateFormat3, nil];
	dates = [[NSMutableDictionary alloc] init]; 
}

- (void) awakeFromNib
{
	[table setDoubleAction:@selector(onClick:)];
	[table setTarget:self];
}

- (void)reset:(NSArray*)newFiles;
{
	
	files = [[NSMutableArray alloc ] init];
	for (FileSystemNode *n in newFiles) {
		if (!n.isDirectory) [files addObject:n];
	}
	
	self.query =@"";
	[selectAlbumButton setEnabled:NO];
	searchResults = [[NSArray alloc] init];
	[table reloadData];
	tags = 	[files[0] tags];
    
    NSArray *comps = [[[files[0] URL] filePathURL] pathComponents];
    directory = comps[ [comps count] - 2 ];
}


@end
