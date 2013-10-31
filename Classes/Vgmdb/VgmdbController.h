//
//  VgmdbController.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Vgmdb.h"

@class DisplayController;
@class FileSystemNode;
@class Tags;


/// This class allows the user to serach for albums on vgmdb
@interface VgmdbController : NSWindowController <QLPreviewPanelDataSource, QLPreviewPanelDelegate> {
@private
	IBOutlet NSWindow *window;
	IBOutlet NSTableView *table;
	IBOutlet NSButton *selectAlbumButton;
	
	NSArray *searchResults;
	NSArray *languages;
	NSString *selectedLanguage;
	
	DisplayController *ssc;
	Tags *tags;
    NSString *directory;
	NSTableView *mainTable;
    
	NSString *currentColumnKey;
    
	BOOL currentColumnAscending;
    
    Vgmdb *vgmdb;
    QLPreviewPanel* previewPanel;
}

@property (strong) NSMutableArray *files;
@property  NSString *query;

/// @name Init

/// array of FileSystemNode
- (id)initWithFiles:(NSArray*)newFiles
			  table:(NSTableView*)table;

/// Reset all the fields to their default values
- (void)reset:(NSArray*)newFiles;

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

- (IBAction)cancelSheet:sender;

- (IBAction)useAlbumForQuery:(id)sender;
- (IBAction)useArtistForQuery:(id)sender;
- (IBAction)useCommentForQuery:(id)sender;


@end
