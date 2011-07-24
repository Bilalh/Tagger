//
//  VgmdbController.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import "VgmdbController.h"
#import "DisplayController.h"
#import "Utility.h"
#import "FileSystemNode.h"
#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface VgmdbController()
- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;
@end

@implementation VgmdbController
@synthesize files, query;

#pragma mark -
#pragma mark GUI Callbacks

- (IBAction)changeDisplayLanguage:(id)sender 
{
    NSButtonCell *selCell = [sender selectedCell];
    NSLog(@"Selected cell is %@", [languages objectAtIndex:[selCell tag]]);
	selectedLanguage = [languages objectAtIndex:[selCell tag]];
	[table setNeedsDisplayInRect:
	 [table rectOfColumn:
	  [table columnWithIdentifier:@"album"]]];
	
}

- (IBAction) searchForAlbums:(id)sender
{
	NSLog(@"Search button pressed");
	searchResults = [vgmdb performRubySelector:@selector(search:)
								 withArguments:query, 
					 nil];
	[table reloadData];
}

- (IBAction) selectAlbum:(id)sender{
	
	if (ssc != nil){
		[ssc release];
	}
	
	ssc = [[DisplayController alloc] 
		   initWithUrl:[[searchResults objectAtIndex:[table selectedRow]] 
											   objectForKey:@"url"]
		   vgmdb:vgmdb];
	
	[self confirmSheet:nil];
}

#pragma mark -
#pragma mark Table Methods 

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[selectAlbumButton setEnabled:([table selectedRow] != -1 ? YES : NO )];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
    return [searchResults count];
}

- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	NSString *s = [Utility valueFromResult:
				   [[searchResults objectAtIndex:rowIndex] 
					objectForKey:[aTableColumn identifier]]
				   selectedLanguage:selectedLanguage];
	return s;
}


#pragma mark -
#pragma mark Sheets 

- (void) didEndSheet:(NSWindow*)sheet 
		  returnCode:(int)returnCode
		  mainWindow:(NSWindow*)mainWindow
{	
	NSLog(@"Search End Sheet");
	[sheet orderOut:self];
	
	if (returnCode == NSOKButton){		
		[NSApp beginSheet: [ssc window]
		   modalForWindow: mainWindow
			modalDelegate: ssc 
		   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
			  contextInfo: nil]; 		
	}
	
}
- (IBAction)cancelSheet:sender
{	
	NSLog(@"Search Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}

- (IBAction)confirmSheet:sender
{
	NSLog(@"Search Comfirm");
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

#pragma mark -
#pragma mark Alloc

- (void)reset:(NSArray*)newFiles;
{
	self.files = newFiles;
	self.query =@"";
	[selectAlbumButton setEnabled:NO];
	searchResults = [[NSArray alloc] init];
	[table reloadData];
}

- (id)initWithFiles:(NSArray*)newFiles
{
	self = [super initWithWindowNibName:@"VgmdbSearch"];
    if (self) {
		
		languages = [[NSArray alloc] initWithObjects:@"@english", @"@romaji",@"@kanji" , nil];
		selectedLanguage = [languages objectAtIndex:0];
		
//		NSString *path = [[NSBundle mainBundle] pathForResource:@"Vgmdb" ofType:@"rb"];
//		[[MacRuby sharedRuntime] evaluateFileAtPath:path];
		vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
		[self reset:newFiles];
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

@end
