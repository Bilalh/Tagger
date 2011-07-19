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

@interface MainController : NSObject {
@private
	IBOutlet NSTextField   *title;
	IBOutlet NSPopUpButton *popup;
	IBOutlet NSTableView   *table;

	
	VgmdbController   *vgc;
	DisplayController *ssc;

	NSMutableArray *parentNodes;
	NSNumber       *selectedNodeindex;
	
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMutableArray *directoryStack;


- (IBAction) onClick:(id)sender;

 /**  
  * Shows the sheet for searching for tags
  * @param sender the object that called this method
  *
  */
- (IBAction) search:(id)sender;

 /**  
  * Changes the current directory if changed by the user and update the gui
  * @param sender the object that called this method
  *
  */
- (IBAction) goToParent:(id)sender;


- (IBAction) getData:(id)sender;

@end
