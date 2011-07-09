//
//  Controller.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MainController.h"
#import "TagsLib.h"
#import "VgmdbController.h"
#import "SettingsSheetController.h"

@implementation MainController

@synthesize title, window, vgc, ssc;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
	
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (IBAction)onTextChange:(id)sender
{
	NSString *s = [sender stringValue] ;
	NSLog(@"Text is Now %@", s );
	if (s != @""){
		TagsLib *tl  = [[TagsLib alloc] initWithFilename:@"/Users/bilalh/Programming/Cocoa/VGTagger/Test Files/aac.m4a"];
		[tl setTitle:s];
	}
	
}

- (IBAction) getData:(id)sender
{
	TagsLib *tl  = [[TagsLib alloc] initWithFilename:@"/Users/bilalh/Programming/Cocoa/VGTagger/Test Files/aac.m4a"];
	
	NSString *s  = [tl getTitle];
	NSLog(@"Title is %@", s);
	[title setStringValue:s];
}

- (IBAction) sheet:(id)sender{
	NSLog(@"sheet");
	if (ssc == nil){
		ssc = [[SettingsSheetController alloc] initWithWindowNibName:@"SettingsSheet"];
	}
	
	[NSApp beginSheet: [ssc window]
	   modalForWindow: self.window
		modalDelegate: ssc 
	   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
		  contextInfo: nil]; 
}

- (IBAction) search:(id)sender{
	NSLog(@"Search");
	if (vgc == nil){
		vgc = [[VgmdbController alloc] initWithWindowNibName:@"VgmdbSearch"];	
	}
	
	[NSApp beginSheet: [vgc window]
	   modalForWindow: self.window
		modalDelegate: vgc 
	   didEndSelector: @selector(didEndSheet:returnCode:mainWindow:)
		  contextInfo: self.window]; 	
}



@end