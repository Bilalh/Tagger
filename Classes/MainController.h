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


@interface MainController : NSObject {
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet NSTextField *title;

@property VgmdbController *vgc;
@property DisplayController *ssc;


- (IBAction)       search:(id)sender;
- (IBAction)      getData:(id)sender;
- (IBAction) onTextChange:(id)sender;

@end
