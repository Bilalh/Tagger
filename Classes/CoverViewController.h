//
//  CoverViewController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 10/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface CoverViewController :  NSViewController <MASPreferencesViewController> {
@private
    
}
@property (assign) IBOutlet NSTokenField *tokenField;

@end
