//
//  NSNumber+compare.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSNumber+compare.h"


@implementation NSNumber (NSNumber_compare)

- (NSComparisonResult)localizedStandardCompare:(NSNumber *)otherNumber
{
	return [self compareMaybeNill:otherNumber];
}

- (NSComparisonResult)compareMaybeNill:(NSNumber *)otherNumber
{
	if (otherNumber == nil) return -1;
	else return [self compare:otherNumber];
}

@end
