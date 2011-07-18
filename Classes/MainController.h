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
	IBOutlet NSTextField *title;
	VgmdbController *vgc;
	DisplayController *ssc;
}

- (IBAction)       search:(id)sender;
- (IBAction)      getData:(id)sender;
-(IBAction)    goToParent:(id)sender;

@property (assign) IBOutlet NSWindow	  *window;
@property (assign) IBOutlet NSPopUpButton *popup;

@property (assign) NSMutableArray       *parentNodes;
@property (assign) NSNumber             *selectedNodeindex;



@end
