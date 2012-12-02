//
//  NSNumber+compare.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 08/08/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber (NSNumber_compare)

- (NSComparisonResult)localizedStandardCompare:(NSNumber *)otherNumber;
- (NSComparisonResult)compareMaybeNill:(NSNumber *)otherNumber;


@end
