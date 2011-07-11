//
//  SettingsSheetController.m
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import "DisplayController.h"
#import "Utility.h"


@implementation DisplayController

-(void)setAlbumUrl:(NSString *)url
{
	NSLog(@"Set Album called, Album Url %@", url );
	albumDetails = [vgmdb performRubySelector:@selector(get_data:)
								withArguments:url, 
					nil];
	NSLog(@"Album\n %@", albumDetails);
}


#pragma mark -
#pragma mark Alloc

-(void) windowDidLoad
{
	NSLog(@"awakeFromNib");
	[album setStringValue:[albumDetails objectForKey:@"title"] ];
}


- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject
{
	vgmdb = vgmdbObject;
	[self setAlbumUrl:url];
	return[self initWithWindowNibName:@"VgmdbDisplay"];
} 

- (void)dealloc
{
    [super dealloc];
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
 

@end;
