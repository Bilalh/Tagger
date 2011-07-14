//
//  TabLibOC.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "Tags.h"
#import "TagStructs.h"

#include <iostream>
#include <string>

#include <fileref.h>
#include <mp4tag.h> 
#include <mp4file.h>

#include <mpegfile.h>


using namespace TagLib;
@implementation Tags

- (id) init
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id) initWithFilename:(NSString *)filename
{
	self = [super init];
	if(self) {
		if(filename == nil) {
			[self release];
			return nil;
		} else {
			data = new FileData;
		}
	}
	
	return self;
}


- (NSString*) getTitle{
	NSLog(@"Abstact class called");
	return nil;
}

- (void) setTitle:(NSString*) newText{
	NSLog(@"Abstact class called");
}


- (void)dealloc
{
    [super dealloc];
	delete data;
}

@end
