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
#import "Track.h"

typedef NSDictionary* (^HashBlock)();

@interface DisplayController() // private methdods
- (id) valuefromDetails:(NSString*)key;
- (void)setAlbumUrl:(NSString *)url;

-(NSDictionary*) makeButtonProperties:(NSString*)b1Title
						  button1Full:(NSString*)b1Full
						 button2Title:(NSString*)b2Title
						  button2Full:(NSString*)b2Full;
@end

@implementation DisplayController

#pragma mark -
#pragma mark Setup

-(void)setAlbumUrl:(NSString *)url
{
	NSLog(@"Set Album called, Album Url %@", url );
	albumDetails = [vgmdb performRubySelector:@selector(get_data:)
								withArguments:url, 
					nil];
//	NSLog(@"Album\n %@", albumDetails);
	tracks =  [vgmdb performRubySelector:@selector(get_tracks_array:)
						   withArguments:albumDetails, 
			   nil];
	NSLog(@"Tracks\n %@", tracks);
	
	album       = [self valuefromDetails:@"title" ];
	artist      = [self valuefromDetails:@"composer"];
	albumArtist = @"";
	year        = [self valuefromDetails:@"year"];
	genre       = [self valuefromDetails:@"category"];	
	totalTracks = [NSNumber numberWithInt:65] ;
	totalDisks  = [self valuefromDetails:@"total_discs"];
	catalog     = [self valuefromDetails:@"catalog"];
	compiltation = NO;
	
	arranger  = [self valuefromDetails:@"arranger"];
	performer = [self valuefromDetails:@"performer"];
	performer = [self valuefromDetails:@"performer"];
	products  = [self valuefromDetails:@"products"];
	publisher = [self valuefromDetails:@"publisher"];
	notes     = [self valuefromDetails:@"notes"];
	
}

-(id) valuefromDetails:(NSString*)key
{
	return [Utility valueFromResult:[albumDetails objectForKey:key] 
				   selectedLanguage:selectedLanguage];
}


#pragma mark -
#pragma mark Table Methods 

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
	//	[selectAlbumButton setEnabled:([table selectedRow] != -1 ? YES : NO )];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
	return [tracks count];
}

- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	id result = [[tracks objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
	if ([result isKindOfClass:[NSDictionary class]]){
		return [Utility stringFromTitle:result 
					   selectedLanguage:@"@romaji"];
	}
	return result;
}


#pragma mark -
#pragma mark Alloc


- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject
{
	vgmdb            = vgmdbObject;
	selectedLanguage = @"@english";
	[self setAlbumUrl:url];
	
	HashBlock hb     = ^{
		return [self makeButtonProperties:@"R"
							  button1Full:@"@romaji" 
							 button2Title:@"K" 
							  button2Full:@"@kanji"];
	};
		
	otherLanguagesProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
							hb(), @"album", 
							nil];	
	
	return[self initWithWindowNibName:@"VgmdbDisplay"];
} 



-(NSDictionary*) makeButtonProperties:(NSString*)b1Title
						  button1Full:(NSString*)b1Full
						 button2Title:(NSString*)b2Title
						  button2Full:(NSString*)b2Full
{

	NSMutableDictionary *button1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									b1Title,       @"title",
									b1Full,        @"full",
									[NSNumber numberWithBool:YES],@"hidden",
									nil];
	
	NSMutableDictionary *button2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									b2Title,       @"title",
									b2Full,        @"full",
									[NSNumber numberWithBool:NO],@"hidden",
									nil];
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			button1, @"button1",
			button2, @"button2",
			nil];
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
	NSLog(@"album        %@", album       );
	NSLog(@"artist       %@", artist      );
	NSLog(@"albumArtist  %@", albumArtist );
	NSLog(@"year         %@", year        );
	NSLog(@"genre        %@", genre       );
	NSLog(@"totalTracks  %@", totalTracks );
	NSLog(@"totalDisks   %@", totalDisks  );
	NSLog(@"catalog      %@", catalog     );
	NSLog(@"compiltation %d", compiltation);

	
	NSLog(@"arranger     %@", arranger    );  
	NSLog(@"composer     %@", composer    );  
	NSLog(@"performer    %@", performer   );
	NSLog(@"products     %@", products    );
	NSLog(@"publisher    %@", publisher   );
	NSLog(@"notes        %@", notes       );
	
	[sheet orderOut:self];
}
 

@end;
