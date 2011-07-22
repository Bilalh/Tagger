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


/// Converts the String to a unsigned int
- (unsigned int)unsignedIntValue;
/// Converts the String to a unsigned long
- (unsigned long)unsignedLongValue;

@end
