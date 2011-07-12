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

@interface DisplayController() // private methdods
- (id) valuefromDetails:(NSString*)key;
- (void)setAlbumUrl:(NSString *)url;

-(NSDictionary*) makeButtonProperties:(NSString*)b1Title
						  button1Full:(NSString*)b1Full
						 button2Title:(NSString*)b2Title
						  button2Full:(NSString*)b2Full;
@end

@implementation DisplayController

- (id)valueForUndefinedKey:(NSString *)key
{
	NSLog(@"valueForUndefinedKey:%@",key);
	return @"AA";
}

#pragma mark -
#pragma mark Gui callback


-(IBAction) changeLanguage:(NSDictionary*)properties
		  buttonProperties:(NSDictionary*)buttonProperties
{
	NSLog(@"fieldProperties \n%@ ", properties);
	NSLog(@"buttonProperties \n%@ ", buttonProperties);
}


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
//	NSLog(@"Tracks\n %@", tracks);
	
	fieldValues = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
				   [self valuefromDetails:@"album"],       @"album",
				   [self valuefromDetails:@"artist"],      @"artist",
				   @"",             @"albumArtist",
				   [self valuefromDetails:@"year"],        @"year",
				   [self valuefromDetails:@"genre"],       @"genre",
				   [NSNumber numberWithInt:65],            @"totalTracks",
				   [self valuefromDetails:@"totalDiscs"],  @"totalDiscs",
				   [self valuefromDetails:@"catalog"],     @"catalog",
				   [NSNumber numberWithBool:NO],           @"compilation",
				   
				   [self valuefromDetails:@"composer" ], @"composer",
				   [self valuefromDetails:@"performer"], @"performer",
				   [self valuefromDetails:@"arranger" ], @"arranger",
				   [self valuefromDetails:@"products" ], @"products",
				   [self valuefromDetails:@"publisher"], @"publisher",
				   [self valuefromDetails:@"notes"    ], @"notes",
				   nil ];

	NSLog(@"fieldProperties\n %@", fieldProperties);
	NSLog(@"fieldValues\n %@", fieldValues);
	
}



-(id) valuefromDetails:(NSString*)key
{
	return [Utility valueFromResult:[albumDetails objectForKey:key] 
				   selectedLanguage:[[fieldProperties objectForKey:key] 
									 objectForKey:@"language"]];
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
	
	NSDictionary* (^hb)() = ^{
		return [self makeButtonProperties:@"R"
							  button1Full:@"@romaji" 
							 button2Title:@"K" 
							  button2Full:@"@kanji"];
	};
	NSDictionary* (^hc)() = ^{
		return (NSDictionary*) [[NSDictionary alloc] initWithObjectsAndKeys:
								[selectedLanguage copy], @"language",
								nil];
	};
	
	fieldProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
							hb(), @"album"       ,
							hb(), @"artist"      ,
							hc(), @"albumArtist" ,
							hc(), @"year"        ,
							hc(), @"genre"       ,
							hc(), @"totalTracks" ,
							hc(), @"totalDisks"  ,
							hc(), @"catalog"     ,
							hc(), @"compilation" ,
							
							hb(), @"arranger"    ,
							hb(), @"composer"    ,
							hb(), @"performer"   ,
							hb(), @"products"    ,
							hb(), @"publisher"   ,
							hc(), @"notes"       ,
							nil];	
	
	[self setAlbumUrl:url];
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
									[NSNumber numberWithBool:NO],@"hidden",
									nil];
	
	NSMutableDictionary *button2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									b2Title,       @"title",
									b2Full,        @"full",
									[NSNumber numberWithBool:NO],@"hidden",
									nil];
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:
			button1, @"button1",
			button2, @"button2",
			[selectedLanguage copy], @"language",
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
	NSLog(@"album        %@", [fieldValues objectForKey:@"album"       ]);
	NSLog(@"artist       %@", [fieldValues objectForKey:@"artist"      ]);
	NSLog(@"albumArtist  %@", [fieldValues objectForKey:@"albumArtist" ]);
	NSLog(@"year         %@", [fieldValues objectForKey:@"year"        ]);
	NSLog(@"genre        %@", [fieldValues objectForKey:@"genre"       ]);
	NSLog(@"totalTracks  %@", [fieldValues objectForKey:@"totalTracks" ]);
	NSLog(@"totalDiscs   %@", [fieldValues objectForKey:@"totalDiscs"  ]);
	NSLog(@"catalog      %@", [fieldValues objectForKey:@"catalog"     ]);
	NSLog(@"compilation  %@", [fieldValues objectForKey:@"compilation" ]);

	NSLog(@"arranger     %@", [fieldValues objectForKey:@"arranger"    ]);  
	NSLog(@"composer     %@", [fieldValues objectForKey:@"composer"    ]);  
	NSLog(@"performer    %@", [fieldValues objectForKey:@"performer"   ]);
	NSLog(@"products     %@", [fieldValues objectForKey:@"products"    ]);
	NSLog(@"publisher    %@", [fieldValues objectForKey:@"publisher"   ]);
	NSLog(@"notes        %@", [fieldValues objectForKey:@"notes"       ]);
	
	[sheet orderOut:self];
}
 

@end;
