//
//  VGTaggerAppDelegate.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainController;
@class SettingsSheetController;

@interface VGTaggerAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
	MainController *con;
	SettingsSheetController * ssc;
}

@property (assign) IBOutlet NSWindow *window;
-(IBAction)showSheet:(id)sender;


@end
