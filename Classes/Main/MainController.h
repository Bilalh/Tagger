//
//  Controller.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "CCTColorLabelMenuItemView.h"

@class  VgmdbController;
@class  DisplayController;
@class  FileSystemNode;
@class  FileSystemNodeCollection;
@class  RenamingFilesController;
@class  DraggableImageView;
@class  CCTLabelPickerController;
@class  Tags;

/// The main controller creates the other controllers 
@interface MainController : NSWindowController 
<QLPreviewPanelDataSource, QLPreviewPanelDelegate, CCTColorLabelMenuItemViewDelegate> {
@private
	
	IBOutlet NSPopUpButton *popup;
	IBOutlet NSTableView *table;
	IBOutlet NSToolbarItem *vgmdbItem;
	IBOutlet DraggableImageView *coverView;

	IBOutlet NSMenu *renameMenu;
	IBOutlet NSMenu *tagMenu;
	
	IBOutlet NSMenu *capitaliseMenu;
	IBOutlet NSMenu *uppercaseMenu;
	IBOutlet NSMenu *lowercaseMenu;
	IBOutlet NSMenu *whitespaceMenu;
	IBOutlet NSMenu *deleteMenu;
	
	
	VgmdbController         *vgc;
	DisplayController       *ssc;
	RenamingFilesController *rfc;
	
	NSMutableArray *parentNodes;
	BOOL _vgmdbEnable;
	BOOL _vgmdbEnableDir;
	NSString *currentColumnKey;
	BOOL currentColumnAscending;
	
	QLPreviewPanel* previewPanel;
	NSMenu *labelMenu;
}

/// @name properties

/// The main window
@property (assign) IBOutlet NSWindow *window;
/// The stack of previous directories.
@property (assign) NSMutableArray *directoryStack;
/// The stack of directories to allow the user to go back.
@property (assign) NSMutableArray *forwardStack;

/// The node of the selected row, nil if no row selected.
@property (assign) FileSystemNodeCollection *currentNodes;

/// The selected node in the popup.
@property (assign) NSNumber *selectedNodeindex;
/// The parent nodes of the current directory.
@property (assign) NSMutableArray *parentNodes;

@property (assign) IBOutlet NSTableView *table;

@property (readonly) BOOL forwordStackEnable;
@property (readonly) BOOL backwordStackEnable;
@property (readonly) BOOL vgmdbEnable;
@property (readonly) BOOL vgmdbEnableDir;
@property (readonly) BOOL openEnable;

@property (readonly) NSMenu* labelMenu;

/// @name Directories 

- (void) goToDirectory:(NSURL*)url;

 /**  
  * Changes the current directory if changed by the user and update the gui
  * @param sender the object that called this method
  */
- (IBAction) goToParent:(id)sender;

/** Goes to the previous/forword directory if there is one
 @param sender The back/forword button
 */
- (IBAction) backForwordDirectories:(id)sender; 

- (IBAction) open:(id)sender;
- (IBAction) backDirectories:(id)sender;
- (IBAction) forwordDirectories:(id)sender;
- (IBAction) goToParentMenu:(id)sender;
- (IBAction) goToPredefinedDirectory:(id)sender;

- (IBAction) goToStartingDirectory:(id)sender;
- (IBAction) openDirectory:(id)sender;

/// @name External 

- (IBAction) revealInFinder:(id)sender;
- (IBAction) addSelectedToItunes:(id)sender;

/// @name Table
- (IBAction)gotoNextRow:(id)sender;
- (IBAction)gotoPreviousRow:(id)sender;
- (NSInteger)labelColorForRow:(NSInteger)rowIndex;
- (IBAction)refresh:(id)sender;


/// @name Callback

- (IBAction)rename:(id)sender;
- (IBAction)tagsFromFilename:(id)sender;

- (IBAction)capitalisedTags:(id)sender;
- (IBAction)uppercaseTags:(id)sender;
- (IBAction)lowercaseTags:(id)sender;
- (IBAction)trimWhitespace:(id)sender;
- (IBAction)deleteTags:(id)sender;

- (IBAction)performBlockOnTags:(id)sender
					  tagNames:(const NSArray*)tagNames
						 block:(id (^)(id value, NSString *tagName, Tags *tags ))block;


/**  
 * Shows the sheet for searching for tags
 * @param sender the object that called this method
 */
- (IBAction)search:(id)sender;

/**  
 * Shows the sheet for searching for tags
 * @param sender the object that called this method
 */
- (IBAction)searchWithSubDirectories:(id)sender;


- (IBAction)reopen:(id)sender;

- (IBAction)renumberFiles:(id)sender;



@end
