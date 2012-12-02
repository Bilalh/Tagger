//
//  IntPair.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 24/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "IntPair.h"


@implementation IntPair
@synthesize first, second;


- (id) initWithInts:(NSInteger)fst
			 second:(NSInteger)snd
{
    self = [super init];
    if (self) {
		self.first  = fst;
		self.second = snd;
    }
    return self;
}

@end
