//
//  SettingsSheetController.m
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import "SettingsSheetController.h"


@implementation SettingsSheetController



- (id)initWithWindow:(NSWindow *)awindow
{
    self = [super initWithWindow:awindow];
    if (self) {
    }
    
    return self;
}
- (IBAction)doSomething:(id)sender
{
    NSLog(@"did something");
    
    [textField1 setStringValue:[NSString stringWithFormat:@"random: %i",rand()]];
}

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

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end;
