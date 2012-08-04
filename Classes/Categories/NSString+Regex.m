//
//  NSString+Regex.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 04/08/2012.
//  Copyright (c) 2012 St. Andrews KY16 9XW. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL) hasVaildData
{
    return (self && [self length] != 0 && ![self isMatchedByRegex:@"^[,.()\\~ - \"'\\[\\]:!@]+$"]);
}

@end
