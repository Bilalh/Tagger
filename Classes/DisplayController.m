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
- (id)   valuefromDetails:(NSString*)key;
- (void) setAlbumUrl:(NSString *)url;
- (void) initFieldValues;
- (void) initFieldProperties;
- (void) initButtonsState;

-(NSMutableDictionary*) makeButtonProperties:(NSString*)b1Title
								 button1Full:(NSString*)b1Full
								button2Title:(NSString*)b2Title
								 button2Full:(NSString*)b2Full
										name:(NSString*)name;
@end

@implementation DisplayController

#pragma mark -
#pragma mark Gui callback


-(IBAction) changeLanguage:(NSMutableDictionary*)properties
		  buttonProperties:(NSMutableDictionary*)buttonProperties
{
	
	// swap the language
	NSString *tmp = [properties objectForKey:@"language"];
	[properties setObject:[buttonProperties objectForKey:@"full"]  forKey:@"language"];
	[buttonProperties setObject:tmp forKey:@"full"];
	
	
	[buttonProperties setObject:tmp  forKey:@"full"];
	[buttonProperties setObject:[[tmp substringWithRange:NSMakeRange(1, 1)] 
					capitalizedString] forKey:@"title" ];
	[buttonProperties setObject:[[tmp substringFromIndex:1] 
					capitalizedString] forKey:@"toolTip"  ];
	
	id newValue =[self valuefromDetails:[properties objectForKey:@"name"]];
	[fieldValues setObject:newValue forKey:[properties objectForKey:@"name"]];
	
	NSLog(@"fieldProperties \n%@ ", properties);
	NSLog(@"buttonProperties \n%@ ", buttonProperties);

	
}

- (IBAction)changeTableLanguage:(id)sender 
{
    NSInteger tag = [[sender selectedCell] tag];
	selectedLanguage = [[[fieldProperties objectForKey:@"radio"] 
						objectForKey: [NSNumber numberWithInteger:tag]] 
						objectForKey: @"language"];
	
	[table setNeedsDisplayInRect:
	 [table rectOfColumn:
	  [table columnWithIdentifier:@"title"]]];
	
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
	NSString **sPtr = &selectedLanguage;
	id result = [[tracks objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
	if ([result isKindOfClass:[NSDictionary class]]){
		return [Utility stringFromLanguages:result 
					   selectedLanguage:sPtr];
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
	languages        = [[NSArray alloc] initWithObjects:@"@english", @"@romaji",@"@kanji" , nil];
	
	[self initFieldProperties];
	[self setAlbumUrl:url];
	[self initFieldValues];	
	[self initButtonsState];

	return[self initWithWindowNibName:@"VgmdbDisplay"];	
} 

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Setup


- (void) initFieldProperties 
{
	NSMutableDictionary* (^hb)(NSString*) = ^(NSString *name){
		return [self makeButtonProperties:@"R"
							  button1Full:@"@romaji" 
							 button2Title:@"K" 
							  button2Full:@"@kanji"
									 name:name];
	};
	NSMutableDictionary* (^hc)(NSString*) = ^(NSString *name){
		return (NSMutableDictionary*) [[NSMutableDictionary alloc] initWithObjectsAndKeys:
								[selectedLanguage copy], @"language",
								name, @"name",
								nil];
	};

	NSMutableDictionary* (^hd)(NSString*) = ^(NSString *value){
		return (NSMutableDictionary*) 	[[NSMutableDictionary alloc] initWithObjectsAndKeys:
										 [NSNumber numberWithBool:NO] , @"hidden",
										 value, @"language",
										 nil];
	};
	
	NSMutableDictionary* radio =  hc(@"radio");
	[radio setObject:hd(@"@english") forKey:[NSNumber numberWithInteger:0]];
	[radio setObject:hd(@"@romaji")  forKey:[NSNumber numberWithInteger:1]];
	[radio setObject:hd(@"@kanji")   forKey:[NSNumber numberWithInteger:2]];
	
	
	fieldProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
					   hb(@"album"      ), @"album"       ,
					   hb(@"artist"     ), @"artist"      ,
					   hc(@"albumArtist"), @"albumArtist" ,
					   hc(@"year"       ), @"year"        ,
					   hc(@"genre"      ), @"genre"       ,
					   hc(@"totalTracks"), @"totalTracks" ,
					   hc(@"totalDisks" ), @"totalDisks"  ,
					   hc(@"catalog"    ), @"catalog"     ,
					   hc(@"compilation"), @"compilation" ,
					      
					   hb(@"arranger"   ), @"arranger"    ,
					   hb(@"composer"   ), @"composer"    ,
					   hb(@"performer"  ), @"performer"   ,
					   hb(@"products"   ), @"products"    ,
					   hb(@"publisher"  ), @"publisher"   ,
					   hc(@"notes"      ), @"notes"       ,
					   radio             , @"radio"       ,
					   nil];
}

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
}


- (void) initFieldValues 
{	
	NSMutableArray  *keys = [[NSMutableArray alloc] initWithObjects: 
							 @"composer",
							 @"album",
							 @"artist",
							 @"year",
							 @"genre",
							 @"totalDiscs",
							 @"catalog",
							 @"performer",
							 @"arranger",
							 @"products",
							 @"publisher",
							 @"notes",
							 nil ];
	NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[keys count]+3];
	
	for (NSString *key in keys) {
		
		NSString *s = [[fieldProperties objectForKey:key] objectForKey:@"language"];
		id obj =  [Utility valueFromResult:[albumDetails objectForKey:key] 
					   selectedLanguagePtr:&s];

		[[fieldProperties objectForKey:key] setObject:s forKey:@"language"];
		
		[values addObject:obj];
	}
	
	[keys addObject:@"albumArtist"];
	[values addObject:@""];
	[keys addObject:@"totalTracks"];
	[values addObject:[NSNumber numberWithInt:65]];
	[keys addObject:@"compilation"];
	[values addObject:[NSNumber numberWithBool:NO]];
	
	fieldValues = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
	
	NSLog(@"fieldValues\n %@", fieldValues);
	
}

- (void) initButtonsState
{
	NSMutableArray  *keys = [[NSMutableArray alloc] initWithObjects: 
							 @"album",    @"artist",
							 @"composer", @"performer",
							 @"arranger", @"products",
							 @"publisher", nil ];
	
	
	NSDictionary* languagesDictionary = [Utility languagesDictionary];
	
	for (NSString *key in keys) {
		NSArray *other = [languagesDictionary objectForKey: 
						  [[fieldProperties objectForKey:key] objectForKey:@"language"] ];
		int len = (int) MIN([other count], 2);
		int i, index;
		for (i =0, index=1; i< len; ++i) {
			
			id  field = [albumDetails objectForKey:key];
			if ([field isKindOfClass: [NSArray class] ] && [field count] > 0 ){
				field = [field objectAtIndex:0];
			}
			
			NSMutableDictionary *d = field;
			if ([d objectForKey: [other objectAtIndex:i]]){
				NSMutableDictionary *btn= [[fieldProperties objectForKey:key] objectForKey:
										   [NSString stringWithFormat:@"button%d",index] ];
				[btn setObject:[NSNumber numberWithBool:NO] forKey:@"hidden"];
				[btn setObject:[other objectAtIndex:i ]     forKey:@"full" ];
				[btn setObject:[[[other objectAtIndex:i] substringWithRange:NSMakeRange(1, 1)] 
								capitalizedString] forKey:@"title" ];
				[btn setObject:[[[other objectAtIndex:i] substringFromIndex:1] 
								capitalizedString] forKey:@"toolTip"  ];
				++index;
			}
			
		}
		
	}
	
}


-(NSMutableDictionary*) makeButtonProperties:(NSString*)b1Title
								 button1Full:(NSString*)b1Full
								button2Title:(NSString*)b2Title
								 button2Full:(NSString*)b2Full
										name:(NSString*)name
{

	NSMutableDictionary *button1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									b1Title,       @"title",
									b1Full,        @"full",
									b1Full,        @"toolTip",
									[NSNumber numberWithBool:YES],@"hidden",
									nil];
	
	NSMutableDictionary *button2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									b2Title,       @"title",
									b2Full,        @"full",
									b2Full,        @"toolTip",
									[NSNumber numberWithBool:YES],@"hidden",
									nil];
	
	return [[NSMutableDictionary alloc] initWithObjectsAndKeys:
			button1, @"button1",
			button2, @"button2",
			[selectedLanguage copy], @"language",
			name, @"name",
			nil];
}


-(id) valuefromDetails:(NSString*)key
{
	return [Utility valueFromResult:[albumDetails objectForKey:key] 
				   selectedLanguage:[[fieldProperties objectForKey:key] 
									 objectForKey:@"language"]];
}

#pragma mark -
#pragma mark Sheet

- (IBAction)cancelSheet:sender
{	
	NSLog(@"Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}


- (IBAction)confirmSheet:sender
{
	NSLog(@"Comfirm");
	[NSApp endSheet:self.window returnCode:NSOKButton];
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

#pragma mark -
#pragma mark Misc

- (id)valueForUndefinedKey:(NSString *)key
{
	NSLog(@"valueForUndefinedKey:%@",key);
	return @"ERROR";
}

@end;
;