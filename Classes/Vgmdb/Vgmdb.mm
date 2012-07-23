//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import "Vgmdb.h"
#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);

#include <htmlcxx/html/ParserDom.h>
#include "VgmdbStruct.h"

@implementation Vgmdb

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"ddd");
    }
    return self;
}


@end
