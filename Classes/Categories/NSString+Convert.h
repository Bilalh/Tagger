//
//  NSString+Convert.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 15/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>

/// Converts NSString to TagLib::String and back again
@interface NSString (NSString_Convert)


- (std::string*) cppString;
/// Converts a std::string* to a NSString 
- (NSString*) initWithCppString:(std::string*) cppString;

@end
