//
//  TabLibOC.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


struct TagsLibImpl;
@interface TagsLib : NSObject {
	struct TagsLibImpl* impl;
}

-(id) initWithFilename:(NSString*)filename;
-(NSString*)getTitle;

@property (assign) struct TagsLibImpl* impl;

@end
