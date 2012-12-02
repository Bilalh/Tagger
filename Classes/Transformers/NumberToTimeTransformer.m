//
//  NumberToTimeTransformer.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 25/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "NumberToTimeTransformer.h"


@implementation NumberToTimeTransformer

+ (Class)transformedValueClass {
	return [NSString class]; 
}

+ (BOOL)allowsReverseTransformation { 
	return NO; 
}

- (id)transformedValue:(id)value {
	if (value != nil) return @"0:00";
	
	const int totalSeconds = [value intValue];
	const int seconds = totalSeconds % 60;
	const int minutes = totalSeconds / 60;
	return [NSString stringWithFormat:@"%d:%d",minutes, seconds];
}

@end
