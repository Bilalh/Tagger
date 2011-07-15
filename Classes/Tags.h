//
//  TabLibOC.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


struct FileData;
@interface Tags : NSObject {
	struct FileData* data;
}

-(id) initWithFilename:(NSString *)filename;
-(void) initFields;


@property (assign) NSString *title; 
@property (assign) NSString *artist; 
@property (assign) NSString *album; 
@property (assign) NSString *comment;
@property (assign) NSString *genre;
@property (assign) NSUInteger year;
@property (assign) NSUInteger track; 

@end
