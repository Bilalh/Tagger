//
//  SettingsSheetController.m
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import "SettingsSheetController.h"


@implementation SettingsSheetController

-(void)setAlbum:(NSString *)url
{
	
}

#pragma mark -
#pragma mark Sheet

- (IBAction)confirmSheet:sender
{
	NSLog(@"Comfirm");
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

- (IBAction)cancelSheet:sender
{	
	NSLog(@"Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}

- (void) didEndSheet:(NSWindow*)sheet 
				   returnCode:(int)returnCode
				  contextInfo:(void*)contextInfo
{	
	NSLog(@"End Sheet");
	[sheet orderOut:self];
}


#pragma mark -
#pragma mark Alloc

-(void)reset
{
	
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc
{
    [super dealloc];
}

@end;
