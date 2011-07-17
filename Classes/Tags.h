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


 /**  
  * Creates and finds the tags of the specifed file
  * should be used on one of the subclass e.g MP4Tag
  *
  * @param filename The filepath to the file
  *
  * @return A new Tags 
  */
-(id) initWithFilename:(NSString *)filename;


 /**  
  *  Gives value to the fields class should call this method at init
  */
-(void) initFields;


@property (assign) NSString *title; 
@property (assign) NSString *artist; 
@property (assign) NSString *album; 
@property (assign) NSString *comment;
@property (assign) NSString *genre;
@property (assign) NSUInteger year;
@property (assign) NSUInteger track; 

@end
