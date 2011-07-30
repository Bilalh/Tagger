//
//  Controller.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  VgmdbController;
@class  DisplayController;
@class  FileSystemNode;

/// The main controller creates the other controllers 
@interface MainController : NSObject {
@private
	
	IBOutlet NSPopUpButton *popup;
	IBOutlet NSTableView   *table;

	VgmdbController   *vgc;
	DisplayController *ssc;

	NSMutableArray *parentNodes;
}

/// The main window
@property (assign) IBOutlet NSWindow *window;
/// The stack of previous directories.
@property (assign) NSMutableArray *directoryStack;
/// The stack of directories to allow the user to go back.
@property (assign) NSMutableArray *forwardStack;

/// The node of the selected row, nil if no row selected.
@property (assign) FileSystemNode *currentNode;

/// The selected node in the popup.
@property (assign) NSNumber *selectedNodeindex;
/// The parent nodes of the current directory.
@property (assign) NSMutableArray *parentNodes;


 /**  
  * Shows the sheet for searching for tags
  * @param sender the object that called this method
  */
- (IBAction) search:(id)sender;

 /**  
  * Changes the current directory if changed by the user and update the gui
  * @param sender the object that called this method
  */
- (IBAction) goToParent:(id)sender;

/** Goes to the previous/forword directory if there is one
 
 @param sender The back/forword button
 */
- (IBAction) backForwordDirectories:(id)sender; 

- (IBAction) rename:(id)sender;

@end
