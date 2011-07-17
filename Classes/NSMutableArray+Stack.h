//
//  NSArray+Stack.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 17/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (NSArray_Stack)

- (void)push:(id)inObject;
- (id)pop;

@end
