//
//  Numbers.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 20/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>

/// methods to convert NSString to unsigned int/long
/// needed in MainMenu.xib for the textfields binding
@interface NSString (NSString_Numbers)

- (unsigned int)unsignedIntValue;
- (unsigned long)unsignedLongValue;

@end
