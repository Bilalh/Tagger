//
//  SettingsSheetController.m
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import "SettingsSheetController.h"


@implementation SettingsSheetController

-(void)setAlbum:(NSString *)url
{
	NSLog(@"Album Url %@", url );
	albumDetails = [vgmdb performRubySelector:@selector(get_data:)
								withArguments:url, 
					nil];
	NSLog(@"Album\n %@", albumDetails);
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

-(void) awakeFromNib
{
	NSLog(@"aa");
	[album setStringValue:@"test"];
}


-(void)reset
{
	
}

- (id)initWithWindowNibNameAndVgmdb:(NSString*)nibName
							  vgmdb:(id)vgmdbObject
{
	vgmdb = vgmdbObject;
	return[self initWithWindowNibName:nibName];
} 

- (void)dealloc
{
    [super dealloc];
}

@end;
