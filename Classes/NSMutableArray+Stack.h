//
//  NSArray+Stack.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 17/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (NSArray_Stack)

/// Adds a item to the end  of the array
- (void)push:(id)inObject;
/// Removes the last items and retuns it
- (id)pop;

@end
