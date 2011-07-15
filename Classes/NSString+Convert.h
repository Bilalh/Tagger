//
//  NSString+Convert.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 15/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <tstring.h> 

@interface NSString (NSString_Convert)
- (NSString*) initWithTagString:(TagLib::String) cppString;
+ (NSString*) stringWithTagString:(TagLib::String) cppString;


@end
