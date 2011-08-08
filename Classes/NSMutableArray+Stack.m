//
//  NSArray+Stack.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 17/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (NSArray_Stack)

- (id)pop
{
	id theResult = nil;
	if([self count])
	{
		theResult = [[[self lastObject] retain] autorelease];
		[self removeLastObject];
	}
	return theResult;
}

- (void)push:(id)inObject
{
	if(inObject) [self addObject:inObject];
	
}

@end

