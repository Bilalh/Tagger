//
//  SettingsSheetController.h
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// This class shows the data of the selected album in a sheet
@interface DisplayController : NSWindowController {
@private
	IBOutlet NSWindow    *window;
	id vgmdb;                         /// macruby Vgmdb class
	NSDictionary *albumDetails;       /// contains all the infomation
	
	NSString *selectedLanguage;       /// language of the tracks
	NSArray  *tracks;                 /// array of tracks info
	
	NSMutableDictionary *fieldValues; /// The value of the fields
	NSDictionary *fieldProperties;    /// The properties of the fields and their buttons
	
	IBOutlet NSTableView *table;      /// table of tracks	
}

@property (assign) NSArray *files;

/// @name Initializing an DisplayController Object

 /**  
  *  Setup (Only method for setup).
  *
  * @param url         The url of the result vgmdb page.
  * @param vgmdbObject The pointer to a vgmdb object.
  *
  * @return An new Display Controller.
  */
- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject
			files:(NSArray*)files;

/// @name Changing the language

/** Changes the Language of of the specifed field.
 
 Each field can have a different language, the sender button language is switch with 
 the current language.
  
 @param properties       The properties containg the data about the new language.	
 @param buttonProperties The properties containg the data of the sender button.
 */
- (IBAction)changeLanguage:(NSMutableDictionary*)properties
		  buttonProperties:(NSMutableDictionary*)buttonProperties;



/** Changes the language of the table.
 
 @param sender The radio button of the new selected language.
 */
- (IBAction)changeTableLanguage:(id)sender;

- (IBAction)changeState:(id)sender;

- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;


@end
