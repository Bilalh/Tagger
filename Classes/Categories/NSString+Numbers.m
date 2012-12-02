//
//  Numbers.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 20/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSString+Numbers.h"


@implementation NSString (NSString_Numbers)

- (unsigned long)unsignedLongValue
{ 
	return strtoull([self UTF8String], NULL, 0); 
}

- (unsigned int)unsignedIntValue 
{ 
	return (unsigned int) strtoull([self UTF8String], NULL, 0); 
}

@end
