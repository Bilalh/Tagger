//
//  Vgmdb.h
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>

struct _Vgmdb;

@interface Vgmdb : NSObject

    struct _Vgmdb;

- (NSDictionary*) searchResults:(NSString*)search;

@end