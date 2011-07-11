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

-(id) valuefromDetails:(NSString*)key
{
	return [Utility valueFromResult:[albumDetails objectForKey:key] 
				   selectedLanguage:selectedLanguage];
}

-(void)setAlbumUrl:(NSString *)url
{
	NSLog(@"Set Album called, Album Url %@", url );
	albumDetails = [vgmdb performRubySelector:@selector(get_data:)
								withArguments:url, 
					nil];
	NSLog(@"Album\n %@", albumDetails);
	
	album       = [self valuefromDetails:@"title" ];
	artist      = [self valuefromDetails:@"composer"];
	albumArtist = @"";
	year        = [self valuefromDetails:@"year"];
	genre       = [self valuefromDetails:@"category"];	
	totalTracks = [NSNumber numberWithInt:65] ;
	totalDisks  = [self valuefromDetails:@"total_discs"];
	
	composer  = [self valuefromDetails:@"composer"];
	performer = [self valuefromDetails:@"performer"];
	products  = [self valuefromDetails:@"products"];
	publisher = [self valuefromDetails:@"publisher"];
	notes     = [self valuefromDetails:@"notes"];
	
}


#pragma mark -
#pragma mark Alloc


- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject
{
	vgmdb = vgmdbObject;
	selectedLanguage = @"@english";
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
	NSLog(@"End Sheet Vars:");
	NSLog(@"album       %@", album       );
	NSLog(@"artist      %@", artist      );
	NSLog(@"albumArtist %@", albumArtist );
	NSLog(@"year        %@", year        );
	NSLog(@"genre       %@", genre       );
	NSLog(@"totalTracks %@", totalTracks );
	NSLog(@"totalDisks  %@", totalDisks  );
	
	NSLog(@"composer    %@", composer    );  
	NSLog(@"performer   %@", performer   );
	NSLog(@"products    %@", products    );
	NSLog(@"publisher   %@", publisher   );
	NSLog(@"notes       %@", notes       );
	
	[sheet orderOut:self];
}
 

@end;
