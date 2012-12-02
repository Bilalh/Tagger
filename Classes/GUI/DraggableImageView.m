//
//  DraggableImageView.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "DraggableImageView.h"
#import "FileSystemNode.h"
#import "Tags.h"

@interface DraggableImageView()

@end

@implementation DraggableImageView
@synthesize current;

- (NSString*) makeFilename
{
	if (current.tags){
		NSString * name = [current.tags filenameFromFormatArray:  
						   [[NSUserDefaults standardUserDefaults] 
							arrayForKey:@"coverFormat"]];
		return [name isEqualToString:@""]  ? @"cover" : name;
	}else{
		return @"cover";
	}
}


@end
