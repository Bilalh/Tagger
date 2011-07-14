//
//  TabLibOC.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Cocoa/Cocoa.h>


struct FileData;
@interface Tags : NSObject {
	@private
	struct FileData* data;
}

-(id) initWithMp4Filename:(NSString *)filename;
-(NSString*)getTitle;
-(void) setTitle:(NSString*)newText;

@end
