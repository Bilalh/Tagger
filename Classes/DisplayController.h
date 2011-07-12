//
//  SettingsSheetController.h
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisplayController : NSWindowController {
@private
	IBOutlet NSWindow    *window;
	NSDictionary *albumDetails;
	id vgmdb; // macruby Vgmdb class
	
	NSArray  *tracks;
	NSString *selectedLanguage;
	
	// Infomation
	NSString *album;
	NSString *artist;
	NSString *albumArtist;
	NSNumber *year;
	NSString *genre;
	NSNumber *totalTracks;
	NSNumber *totalDisks;
	NSString *catalog;
	bool      compiltation;
	
	// extra infomation
	NSString *composer;
	NSString *performer;
	NSString *arranger;
	NSString *products;
	NSString *publisher;
	NSString *notes;
	
	// Buttons
	NSDictionary *otherLanguagesProperties;
}

- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;

- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject;




@end
