//
//  NSString+Tag.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 28/07/2012.
//  Copyright (c) 2012 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <tstring.h>

@interface NSString (Tag)


/// Converts a TagLib::String to a NSString
- (NSString*) initWithTagString:(TagLib::String) cppString;
/// Converts a TagLib::String to a NSString (autoreleased)
+ (NSString*) stringWithTagString:(TagLib::String) cppString;

/// Convert the string to a TagLib::String, the memory is allocated with new
- (TagLib::String) tagLibString;

@end

@interface NSURL (Tag)

/// Convert the url to a TagLib::String, the memory is allocated with new
- (TagLib::String) tagLibString;

@end