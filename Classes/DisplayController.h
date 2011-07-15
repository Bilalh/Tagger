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
	id vgmdb; // macruby Vgmdb class
	NSDictionary *albumDetails; // contains all the infomation
	
	NSString *selectedLanguage; // language of the tracks
	NSArray  *tracks; // array of tracks info
	
	NSMutableDictionary *fieldValues; // The value of the fields
	NSDictionary *fieldProperties;    // The properties of the fields and their buttons
	
	IBOutlet NSTableView *table; // table of tracks	
}




 /**  Setup (Only method for setup)
  *
  * @param url         The url of the result vgmdb page
  * @param vgmdbObject The pointer to a vgmdb object
  *
  * @return An new Display Controller 
  */
- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject;

// change the language
-(IBAction) changeLanguage:(NSMutableDictionary*)properties
		  buttonProperties:(NSMutableDictionary*)buttonProperties;

- (IBAction)changeTableLanguage:(id)sender;
- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;



@end
