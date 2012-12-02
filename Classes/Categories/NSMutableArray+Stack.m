//
//  NSArray+Stack.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 17/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (NSArray_Stack)

- (id)pop
{
	id theResult = nil;
	if([self count])
	{
		theResult = [self lastObject];
		[self removeLastObject];
	}
	return theResult;
}

- (void)push:(id)inObject
{
	if(inObject) [self addObject:inObject];
	
}

- (void)swapObjectAtIndex:(NSInteger)index 
					 from:(NSInteger)remove
			  removeFirst:(BOOL)removeFirst
{
	if (removeFirst){
		const id temp = [self objectAtIndex:remove];
		[self removeObjectAtIndex:remove];
		[self insertObject:temp atIndex:index];
	}else{
		[self insertObject:[self objectAtIndex:remove] atIndex:index];
		[self removeObjectAtIndex:remove];
	}
}

@end

