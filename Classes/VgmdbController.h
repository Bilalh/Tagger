//
//  VgmdbController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class DisplayController;

@interface VgmdbController : NSWindowController {
@private
	IBOutlet NSWindow *window;
	IBOutlet NSTableView *table;
	IBOutlet NSTextField *query;
	IBOutlet NSButton *selectAlbumButton;
	
	NSArray *searchResults;
	NSArray *languages;
	NSString *selectedLanguage;
	
	DisplayController *ssc;
	id vgmdb; // macruby Vgmdb class
}


- (IBAction) searchForAlbums:(id)sender;
- (IBAction) selectAlbum:(id)sender;

- (IBAction)findSelectedButton:(id)sender;

- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;

- (void)reset;


@end
