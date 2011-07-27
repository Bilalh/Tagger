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
#import "FileSystemNode.h"
#import "Tags.h"
#import "NSAttributedString+Hyperlink.h"


#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface DisplayController() // private methdods
- (id)   valuefromDetails:(NSString*)key;
- (void) setAlbumUrl:(NSString *)url;
- (void) initFieldValues;
- (void) initFieldProperties;
- (void) initButtonsState;

- (NSMutableDictionary*) makeButtonProperties:(NSString*)b1Title
								 button1Full:(NSString*)b1Full
								button2Title:(NSString*)b2Title
								 button2Full:(NSString*)b2Full
										name:(NSString*)name;
@end

@implementation DisplayController
@synthesize files;

#pragma mark -
#pragma mark Gui callback

- (IBAction)changeState:(id)sender
{
	DDLogVerbose(@"called");
}


- (IBAction) changeLanguage:(NSMutableDictionary*)properties
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
	
	DDLogInfo(@"fieldProperties \n%@ ", properties);
	DDLogInfo(@"buttonProperties \n%@ ", buttonProperties);

	
}

- (IBAction)changeTableLanguage:(id)sender 
{
    NSInteger tag = [[sender selectedCell] tag];
	NSMutableDictionary *radio = [fieldProperties objectForKey:@"radio"];
	
	[radio setObject: 
	 [[radio objectForKey: [NSString stringWithFormat:@"%d",tag ]] 
	  objectForKey: @"language"] forKey:@"language"]; 
	
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

- (NSString*)intToTime:(int)totalSeconds
{
	return [NSString stringWithFormat:@"%d:%02d", totalSeconds/60, totalSeconds %60 ];
}

- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	
	NSString *label =[aTableColumn identifier]; 
	if ([label rangeOfString:@"#File"].location != NSNotFound) {
		
		const id result = [[[files objectAtIndex:rowIndex] tags] valueForKey:
						   [label stringByReplacingOccurrencesOfString:@"#File" withString:@""]];
		
		if ([label isEqualToString:@"length#File"]){
			return [self intToTime:[result intValue] ];
		}
		
		return result;
		
	}else{
		NSString *sPtr =  [[fieldProperties objectForKey:@"radio"] objectForKey:@"language"] ;
		id result = [[tracks objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
		if ([result isKindOfClass:[NSDictionary class]]){
			return [Utility stringFromLanguages:result 
							   selectedLanguage: &sPtr];
		}
		return result;
	}
	
	return @"error";
}


#pragma mark -
#pragma mark Init

- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject
			files:(NSArray*)filesNodes;
{
	vgmdb = vgmdbObject;
	files = [filesNodes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		FileSystemNode *a = obj1, *b = obj2;
		NSComparisonResult res = [a.tags compare:b.tags];
		
		if (res ==  NSOrderedSame) res = [a.displayName compare:b.displayName];
		return res;
	}];
	
	selectedLanguage = @"@english";

	DDLogVerbose(@"----");
	[self initFieldProperties];
	DDLogVerbose(@"----");
	[self setAlbumUrl:url];
	DDLogVerbose(@"----");
	[self initFieldValues];	
	DDLogVerbose(@"----");
	[self initButtonsState];
	DDLogVerbose(@"----");
	
	NSDictionary *title = [[tracks objectAtIndex:0] objectForKey:@"title"];
	NSDictionary *radio = [fieldProperties objectForKey:@"radio"];

	NSString *l[] = {@"@english", @"@romaji",@"@kanji"};
	
	int i;
	for (i =0; i < sizeof(l)/sizeof(size_t) ; ++i) {
		if ([title objectForKey:l[i]] ){
			[[radio objectForKey:[NSString stringWithFormat:@"%d", i]] setObject:[NSNumber numberWithBool:YES ] forKey:@"enable"];
		}
	}	
	DDLogVerbose(@"----");
	
	
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
								[NSNumber numberWithBool:YES], @"write",
								[selectedLanguage copy], @"language",
								name, @"name",
								nil];
	};

	NSMutableDictionary* (^hd)(NSString*) = ^(NSString *value){
		return (NSMutableDictionary*) 	[[NSMutableDictionary alloc] initWithObjectsAndKeys:
										 [NSNumber numberWithBool:NO] , @"enable",
										 value, @"language",
										 nil];
	};
	
	NSMutableDictionary* radio =  hc(@"radio");
	[radio setObject:hd(@"@english") forKey:@"0"];
	[radio setObject:hd(@"@romaji")  forKey:@"1"];
	[radio setObject:hd(@"@kanji")   forKey:@"2"];
	
	
	fieldProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
					   hb(@"album"      ), @"album"       ,
					   hb(@"artist"     ), @"artist"      ,
					   hc(@"albumArtist"), @"albumArtist" ,
					   hc(@"year"       ), @"year"        ,
					   hc(@"genre"      ), @"genre"       ,
					   hc(@"totalDiscs" ), @"totalDiscs"  ,
					   hc(@"catalog"    ), @"catalog"     ,
					   hc(@"compilation"), @"compilation" ,
					      
					   hb(@"arranger"   ), @"arranger"    ,
					   hb(@"composer"   ), @"composer"    ,
					   hb(@"performer"  ), @"performer"   ,
					   hb(@"products"   ), @"products"    ,
					   hb(@"publisher"  ), @"publisher"   ,
					   hc(@"comment"    ), @"comment"     ,
					   radio             , @"radio"       ,
					   nil];
}

-(void)setAlbumUrl:(NSString *)url
{
	DDLogInfo(@"Set Album called, Album Url %@", url );
	albumDetails = [vgmdb performRubySelector:@selector(get_data:)
								withArguments:url, 
					nil];
//	DDLogInfo(@"Album\n %@", albumDetails);
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
							 @"comment",
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
	
	fieldValues = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
	[fieldValues setObject: @"http://vgmdb.net/album/25409" forKey:@"url"];	
	
	DDLogInfo(@"fieldValues\n %@", fieldValues);
	
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
		for (i = 0, index = 1; i< len; ++i) {
			
			id  field = [albumDetails objectForKey:key];
			if ([field isKindOfClass: [NSArray class]] ){
				if ([field count] == 0) continue;
				if ([field count] > 0) field = [field objectAtIndex:0];
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
			[NSNumber numberWithBool:YES], @"write",
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
	DDLogInfo(@"Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}

- (void) tagTracks
{
	
	NSString *tracklanguage    =  [[fieldProperties objectForKey:@"radio"] objectForKey:@"language"] ;
	NSMutableArray  *fieldKeys = [[NSMutableArray alloc] initWithObjects: 
							 @"album", @"artist", @"albumArtist",
							 @"year" , @"genre" , @"composer",
							 @"comment",@"totalDiscs",
							 nil ];
	
	NSArray  *nodeKeys = [[NSArray alloc] initWithObjects: 
						  @"track", @"totalTracks", @"disc",
						  nil ];
	
	NSUInteger i;
	for (i =0; i < [tracks count]; ++i) {
		Tags *tags = [[files objectAtIndex:i] tags];
		NSDictionary *data = [tracks objectAtIndex:i];
		
		for (NSString *key in fieldKeys) {
			if ([[[fieldProperties valueForKey:key] valueForKey:@"write"] boolValue]){
				[tags setValue: [fieldValues objectForKey:key]  
						forKey:key];	
			}
		}
		
		id newValue = [data objectForKey:@"title"];
		if ([newValue isKindOfClass:[NSDictionary class]]){
			newValue = [Utility stringFromLanguages:newValue selectedLanguage: &tracklanguage];
		}
		[tags setValue:newValue forKey:@"title"];

		
		for (NSString *key in nodeKeys) {
			newValue = [data objectForKey:key];
			[tags setValue:newValue forKey:key];
		}		
	}
	
	
}
- (IBAction)confirmSheet:sender
{
	DDLogInfo(@"End Sheet Vars:");
	NSLog(@"album        %@", [fieldValues objectForKey:@"album"       ]);
	NSLog(@"artist       %@", [fieldValues objectForKey:@"artist"      ]);
	NSLog(@"albumArtist  %@", [fieldValues objectForKey:@"albumArtist" ]);
	NSLog(@"year         %@", [fieldValues objectForKey:@"year"        ]);
	NSLog(@"genre        %@", [fieldValues objectForKey:@"genre"       ]);
	NSLog(@"totalDiscs   %@", [fieldValues objectForKey:@"totalDiscs"  ]);
	NSLog(@"catalog      %@", [fieldValues objectForKey:@"catalog"     ]);
	
	NSLog(@"arranger     %@", [fieldValues objectForKey:@"arranger"    ]);  
	NSLog(@"composer     %@", [fieldValues objectForKey:@"composer"    ]);  
	NSLog(@"performer    %@", [fieldValues objectForKey:@"performer"   ]);
	NSLog(@"products     %@", [fieldValues objectForKey:@"products"    ]);
	NSLog(@"publisher    %@", [fieldValues objectForKey:@"publisher"   ]);
	NSLog(@"comment      %@", [fieldValues objectForKey:@"comment"       ]);
	
	[self tagTracks ];
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

- (void) didEndSheet:(NSWindow*)sheet 
		  returnCode:(int)returnCode
		 contextInfo:(void*)contextInfo
{	
	
	[sheet orderOut:self];
}

#pragma mark -
#pragma mark Misc

- (id)valueForUndefinedKey:(NSString *)key
{
	DDLogInfo(@"valueForUndefinedKey:%@",key);
	return @"ERROR";
}

@end;
;
