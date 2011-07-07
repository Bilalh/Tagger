//
//  Controller.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MainController : NSObject {
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet NSTextField *title;

- (IBAction) search:(id)sender;
- (IBAction) getData:(id)sender;
- (void)onTextChange:(id)sender;

@end
