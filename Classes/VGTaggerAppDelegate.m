//
//  VGTaggerAppDelegate.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "VGTaggerAppDelegate.h"
#import <MacRuby/MacRuby.h>
#import "SettingsSheetController.h"


@implementation VGTaggerAppDelegate
@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    ssc = [[SettingsSheetController alloc] initWithWindowNibName:@"SettingsSheet"];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Vgmdb" ofType:@"rb"];
	[[MacRuby sharedRuntime] evaluateFileAtPath:path];

	
}

-(IBAction)showSheet:(id)sender
{   
	NSLog(@"Sheet");
    assert ([ssc window]);
    assert (window);
    [NSApp beginSheet: [ssc window]
       modalForWindow: window 
        modalDelegate: ssc 
       didEndSelector: @selector(didEndSheet:returnCode:contextInfo:) 
          contextInfo: nil]; 
}

@end
