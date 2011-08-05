//
//  VGTaggerAppDelegate.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainController;

@interface VGTaggerAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
	NSWindowController *_preferencesWindowController;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) IBOutlet MainController *mainController;
@property (nonatomic, readonly) NSWindowController *preferencesWindowController;

- (IBAction)openPreferences:(id)sender;


@end
