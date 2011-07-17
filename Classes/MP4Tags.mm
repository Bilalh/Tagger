//
//  MP4Tags.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 14/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MP4Tags.h"
#import "TagStructs.h"

#include <iostream>
#include <string>


using namespace TagLib;
@implementation MP4Tags

- (id) initWithFilename:(NSString *)filename
{
    self = [super initWithFilename:filename];
    if (self) {
		data->f->mp4 = new MP4::File([filename UTF8String]);
		data->file = data->f->mp4;
		[self initFields];
    }
    
    return self;	
}


- (NSString*) getTitleTest{
	
	MP4::Tag *t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();
	const char *cstring = map["\251nam"].toStringList().front().toCString(true); 
	return [NSString stringWithUTF8String:cstring];
}

- (void) setTitleTest:(NSString*) newText{
	
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
}

@end
