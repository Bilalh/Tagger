//
//  IntPair.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 24/08/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IntPair : NSObject {    
}

- (id) initWithInts:(NSInteger)first
			 second:(NSInteger)second;

@property (nonatomic, assign) NSInteger first;
@property (nonatomic, assign) NSInteger second;

@end
