//
//  NSString+Tag.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 28/07/2012.
//  Copyright (c) 2012  All rights reserved.
//

#import "NSString+Tag.h"
@implementation NSString (Tag)

- (NSString*) initWithTagString:(TagLib::String) cppString
{
	return [[NSString alloc] initWithUTF8String:cppString.toCString(true)];
}

+ (NSString*) stringWithTagString:(TagLib::String) cppString
{
	return [NSString stringWithUTF8String: cppString.toCString(true)];
}

- (TagLib::String) tagLibString
{
	TagLib::String s = TagLib::String([self UTF8String], TagLib::String::UTF8);
	return s;
}
@end

@implementation NSURL (Tag)

- (TagLib::String) tagLibString
{
    return [[self  absoluteString] tagLibString];
}

@end