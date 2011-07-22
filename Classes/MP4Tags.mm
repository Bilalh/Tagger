//
//  MP4Tags.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 14/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MP4Tags.h"
#import "TagStructs.h"
#import "NSString+Convert.h"

#include <iostream>
#include <string>

#include <mp4tag.h> 
#include <mp4file.h>
#include <mpegfile.h>

#include "MP4Fields.h"

@interface MP4Tags()
- (NSString*) getField:(TagLib::String)field;
- (bool) setFieldWithString:(TagLib::String)field
					  value:(NSString*)value;
@end

using namespace TagLib;
using namespace MP4Fields;

@implementation MP4Tags

#pragma mark -
#pragma mark init/alloc

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
	composer    = [self getField:COMPOSER];
	grouping    = [self getField:GROUPING];
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Fields helpers

- (NSString*) getField:(TagLib::String)field
{
	
	MP4::Tag * const t = data->f->mp4->tag();
	const MP4::ItemListMap &map =  t->itemListMap();
	if (!map.contains(field)) return nil;
		
	const char *cstring = map[field].toStringList().front().toCString(true); 
	return [NSString stringWithUTF8String:cstring];
}


- (bool) setFieldWithString:(TagLib::String)field
					  value:(NSString*)value
{	
	MP4::Tag * const t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();	
	map.insert(field, MP4::Item::Item([value tagLibString]));
	return data->file->save();
}

#pragma mark -
#pragma mark Setters

- (void) setAlbumArtist:(NSString *)newValue
{ 
	NSLog(@"Setting %s from %@ to %@","Album Artist", albumArtist, newValue);
	albumArtist = newValue;
	[self setFieldWithString:ALBUM_ARTIST  value:newValue]; 
}

- (void) setComposer:(NSString *)newValue
{
	NSLog(@"Setting %s from %@ to %@", "Composer", composer, newValue);
	composer = newValue;
	[self setFieldWithString:COMPOSER  value:newValue]; 
}

- (void) setGrouping:(NSString *)newValue
{
	NSLog(@"Setting %s from %@ to %@","Grouping", grouping, newValue);
	grouping = newValue;
	[self setFieldWithString:GROUPING  value:newValue]; 
}

@end
