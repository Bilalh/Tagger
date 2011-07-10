//
//  VgmdbController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class SettingsSheetController;

@interface VgmdbController : NSWindowController {
@private
	IBOutlet NSWindow *window;
	NSArray *searchResults;
}

@property SettingsSheetController *ssc;
@property IBOutlet NSTextField *query;
@property id vgmdb;

- (IBAction) search:(id)sender;
- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;

- (id) valueFromHash:(NSDictionary*)hash
				 key:(NSString*)key;

- (NSString*) valueFromResult:(id)result;

@end
