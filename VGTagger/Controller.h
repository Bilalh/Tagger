//
//  Controller.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Controller : NSObject {

@private
    
}

@property (assign) IBOutlet NSTextField *title;

- (IBAction) search:(id)sender;
- (void)onTextChange:(id)sender;

@end
