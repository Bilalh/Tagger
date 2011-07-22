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

#include <mp4tag.h> 
#include <mp4file.h>
#include <mpegfile.h>

#include "MP4Fields.h"

@interface MP4Tags()
- (NSString*) getField:(TagLib::String)field;
@end

using namespace TagLib;
using namespace MP4Fields;

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

-(void) initFields
{	
	[super initFields];	
	albumArtist = [self getField:ALBUM_ARTIST];
}


- (NSString*) getField:(TagLib::String)field{
	
	MP4::Tag *t = data->f->mp4->tag();
	const MP4::ItemListMap &map =  t->itemListMap();
	if (!map.contains(field)) return nil;
		
	const char *cstring = map[field].toStringList().front().toCString(true); 
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



//aART   		.toStringList()		Album Artist
//\251ART		.toStringList()		Artist
//\251alb		.toStringList()		Album
//\251day		.toStringList()		Year
//\251gen		.toStringList()		Genre
//\251grp		.toStringList()		Grouping
//\251nam		.toStringList()		Title
//\251wrt		.toStringList()		Composer
//\251cmt		.toStringList()		Comment


- (void)dealloc
{
    [super dealloc];
}

@end
