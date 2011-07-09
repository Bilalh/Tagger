//
//  VgmdbController.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import "VgmdbController.h"
#import "SettingsSheetController.h"

@implementation VgmdbController
@synthesize query, vgmdb, ssc;

- (IBAction) search:(id)sender{
	NSLog(@"Search button pressed");
	searchResults = [vgmdb performRubySelector:@selector(search:)
										withArguments:@"Atelier Meruru", 
//										withArguments:[query stringValue], 
							nil];

	NSLog(@"Search Results %@", searchResults);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [searchResults count];
}
- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex {
	
//	NSLog(@"%@", [searchResults objectAtIndex:rowIndex]);
//	NSLog(@"%@", [[searchResults objectAtIndex:rowIndex] 
//				  valueForKey:[aTableColumn identifier]] );
	
	NSString *s = [vgmdb performRubySelector:@selector(get_key:)
							   withArguments:[searchResults objectAtIndex:rowIndex], 
											 [aTableColumn identifier], nil];
    return s;
}

- (id)initWithWindow:(NSWindow *)awindow
{
    self = [super initWithWindow:awindow];
    if (self) {
		
		vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
		searchResults = [vgmdb performRubySelector:@selector(search:)
									 withArguments:@"Atelier Meruru", 
//										withArguments:[query stringValue], 
						 nil];
    }
    
    return self;
}

- (IBAction)confirmSheet:sender
{
	NSLog(@"Search Comfirm");
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

- (IBAction)cancelSheet:sender
{	
	NSLog(@"Search Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}


- (void) didEndSheet:(NSWindow*)sheet 
		  returnCode:(int)returnCode
		 mainWindow:(NSWindow*)mainWindow
{	
	NSLog(@"Search End Sheet");
	[sheet orderOut:self];
	
	if (returnCode == NSOKButton){
		if (ssc == nil){
			ssc = [[SettingsSheetController alloc] initWithWindowNibName:@"SettingsSheet"];
		}
		
		[NSApp beginSheet: [ssc window]
		   modalForWindow: mainWindow
			modalDelegate: ssc 
		   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
			  contextInfo: nil]; 		
	}
	
}

- (void)dealloc
{
    [super dealloc];
}

@end
