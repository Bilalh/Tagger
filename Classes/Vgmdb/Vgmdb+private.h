//
//  Vgmdb+private.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 28/07/2012.
//  Copyright (c) 2012
//

#import "Vgmdb.h"

@interface Vgmdb (__private)

// To allow testing
- (NSArray*) _searchResults:(NSURL*)url;


@end
