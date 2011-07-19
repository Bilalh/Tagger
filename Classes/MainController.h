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
	NSNumber       *selectedNodeindex;
	
}

/// The main window
@property (assign) IBOutlet NSWindow *window;
/// The stack of previous directories
@property (assign) IBOutlet NSMutableArray *directoryStack;
@property (readonly) FileSystemNode *currentNode;
@property (assign) NSString *a;


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


@end
