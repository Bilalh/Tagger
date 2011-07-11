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

@implementation VgmdbController

#pragma mark -
#pragma mark GUI Callbacks

- (IBAction)findSelectedButton:(id)sender 
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
								 withArguments:[query stringValue], 
					 nil];
	//	NSLog(@"Search Results %@", searchResults);
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

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
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

- (void)reset
{
	[query setStringValue:@""];
	[selectAlbumButton setEnabled:NO];
	searchResults = [[NSArray alloc] init];
	[table reloadData];
}

- (id)init
{
    return [self initWithWindowNibName:@"VgmdbSearch"];
}

- (id)initWithWindow:(NSWindow *)awindow
{
    self = [super initWithWindow:awindow];
    if (self) {
		
		languages = [[NSArray alloc] initWithObjects:@"@english", @"@romaji",@"@kanji" , nil];
		selectedLanguage = [languages objectAtIndex:0];
		vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
		[self reset];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
