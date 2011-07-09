//
//  VgmdbController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TagsLib;

@interface VgmdbController : NSWindowController {
	IBOutlet NSWindow *window;    
}

@property IBOutlet NSTextField *query;
@property id vgmdb;

- (IBAction) search:(id)sender;

@end
