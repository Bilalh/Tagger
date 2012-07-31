//
//  NSString+Convert.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 15/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (NSString_Convert)

- (NSString*) initWithCppString:(std::string*) cppString
{
	return [[NSString alloc] initWithUTF8String:cppString->c_str() ];
}

- (NSString*) trimWhiteSpace
{
    return  [self stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];

}

+ (NSString*) stringWithCppStringTrimmed:(std::string*) cppString
{
	NSString *s =  [[NSString alloc] initWithUTF8String:cppString->c_str() ];
    return  [s trimWhiteSpace];
}


- (std::string*) cppString
{
	std::string *s  = new std::string([self UTF8String]);
	return s;
}


@end
