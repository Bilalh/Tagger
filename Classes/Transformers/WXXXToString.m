//
//  WXXXToString.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 31/10/2013.
//  Copyright 2013  All rights reserved.
//

#import "WXXXToString.h"
#import "RegexKitLite.h"

@implementation WXXXToString

+ (Class)transformedValueClass {
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
	return NO;
}

- (id)transformedValue:(id)value {

    NSString *s = [value stringByReplacingOccurrencesOfRegex:@"^.*http" withString:@"http"];
    return s;
}

@end
