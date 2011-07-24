//
//  VgmdbController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class DisplayController;
@class FileSystemNode;

/// This class allows the user to serach for albums on vgmdb
@interface VgmdbController : NSWindowController {
@private
	IBOutlet NSWindow *window;
	IBOutlet NSTableView *table;
	IBOutlet NSTextField *query;
	IBOutlet NSButton *selectAlbumButton;
	
	NSArray *searchResults;
	NSArray *languages;
	NSString *selectedLanguage;
	
	DisplayController *ssc;
	id vgmdb; // macruby Vgmdb class
}

/// array of FileSystemNode
- (id)initWithFiles:(NSArray*)newFiles;

/// @name Searching for albums

 /**  
  * Search vgmdb for albums.
  * @param sender a object can repsonds to stringValue.
  */
- (IBAction) searchForAlbums:(id)sender;

 /**  
  * Select the specifed album and display the data of it.
  * @param sender unused.
  */
-(IBAction) selectAlbum:(id)sender;

/// @name Changes the language

/** Changes the language of the results.
 
 @param sender The radio button of the new selected language.
 */
- (IBAction)changeDisplayLanguage:(id)sender;

/// @name Other methods

/// Reset all the fields to their default values
- (void)reset:(NSArray*)newFiles;


@property (assign) NSArray* files;

@end
