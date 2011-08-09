//
//  NSString+Convert.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 15/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>
#include <tstring.h> 
#include <string>

/// Converts NSString to TagLib::String and back again
@interface NSString (NSString_Convert)

/// Converts a TagLib::String to a NSString 
- (NSString*) initWithTagString:(TagLib::String) cppString;
/// Converts a TagLib::String to a NSString (autoreleased)
+ (NSString*) stringWithTagString:(TagLib::String) cppString;

/// Convert the string to a TagLib::String, the memory is allocated with new
- (TagLib::String) tagLibString;

- (std::string*) cppString;
/// Converts a std::string* to a NSString 
- (NSString*) initWithCppString:(std::string*) cppString;

@end
