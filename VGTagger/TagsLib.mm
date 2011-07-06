//
//  TabLibOC.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "TagsLib.h"
#include <fileref.h>
#include <fileref.h>
#include <mp4tag.h> 
#include <iostream>
#include <string>
struct TagsLibImpl{
	TagLib::FileRef file;
};

using namespace TagLib;
using namespace std;

@implementation TagsLib

@synthesize impl;

- (id) initWithFilename:(NSString *)filename{
	
	self = [super init];
	if(self) {
		if(filename == nil) {
			[self release];
			return nil;
		} else {
			impl = new TagsLibImpl;
			impl->file = FileRef([filename UTF8String]);
		}
	}
	
	return self;
}


- (NSString*) getTitle{
	
	MP4::Tag *t = dynamic_cast<MP4::Tag*>(impl->file.tag());
	MP4::ItemListMap &map =  t->itemListMap();
	const char *cstring = map["\251nam"].toStringList().front().toCString(); 
	return [NSString stringWithUTF8String:cstring];
}

- (void)dealloc
{
    [super dealloc];
	delete impl;
}

@end
