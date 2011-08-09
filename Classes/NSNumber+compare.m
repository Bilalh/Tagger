//
//  NSNumber+compare.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSNumber+compare.h"


@implementation NSNumber (NSNumber_compare)

- (NSComparisonResult)localizedStandardCompare:(NSNumber *)number
{
	return [self compare:number];
}

@end
