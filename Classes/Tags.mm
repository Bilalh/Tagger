//
//  TabLibOC.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "Tags.h"

#include <iostream>
#include <string>

#include <fileref.h>
#include <mp4tag.h> 
#include <mp4file.h>

#include <mpegfile.h>


union FileDetails{
	TagLib::MP4::File  *mp4;
	TagLib::MPEG::File *mpeg;
};

struct FileData{
	TagLib::File *file;
	FileDetails *f;
};

using namespace TagLib;
@implementation Tags


- (id) initWithMp4Filename:(NSString *)filename{
	self = [super init];
	if(self) {
		if(filename == nil) {
			[self release];
			return nil;
		} else {
			data = new FileData;
			data->f->mp4 = new MP4::File([filename UTF8String]);
			data->file = data->f->mp4;
		}
	}
	
	return self;
}


- (NSString*) getTitle{
		
	MP4::Tag *t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();
	const char *cstring = map["\251nam"].toStringList().front().toCString(); 
	return [NSString stringWithUTF8String:cstring];
}

- (void) setTitle:(NSString*) newText{
	 
	MP4::Tag *t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();
	
	String s = String([newText UTF8String], String::UTF8);
	std::cout << s << std::endl;
	
	String key = String("\251nam");
	map.insert(key, MP4::Item::Item(s));
	
	data->file->save();
	NSLog(@"Saved");
}


- (void)dealloc
{
    [super dealloc];
	delete data;
}

@end
