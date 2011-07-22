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
- (NSString*) getFieldWithString:(TagLib::String)field;
- (TagLib::MP4::Item) getField:(TagLib::String)field;
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
	const MP4::Item::IntPair tracks = [self getField:TRACK_NUMBER].toIntPair();
	const MP4::Item::IntPair disks  = [self getField:DISK_NUMBER].toIntPair();

	albumArtist = [self getFieldWithString:ALBUM_ARTIST];
	composer    = [self getFieldWithString:COMPOSER];
	grouping    = [self getFieldWithString:GROUPING];
	bpm         = [NSNumber numberWithInt:[self getField:BPM].toInt()];
	disk        = [NSNumber numberWithInt:disks.first];
	totalDisks  = [NSNumber numberWithInt:disks.second];
	totalTracks = [NSNumber numberWithInt:tracks.second];
	complication =[NSNumber numberWithBool:[self getField:COMPILATION].toBool()];
	
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Fields helpers


- (MP4::Item) getField:(TagLib::String)field
{
	MP4::Tag * const t = data->f->mp4->tag();
	const MP4::ItemListMap &map =  t->itemListMap();
	if (!map.contains(field)) return 0;
	
	return  map[field];
}


- (NSString*) getFieldWithString:(TagLib::String)field
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
	map.insert(field,StringList([value tagLibString]));
	return data->file->save();
}

- (bool) setField:(TagLib::String)field
					  value:(MP4::Item)valueItem
{	
	MP4::Tag * const t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();	
	map.insert(field,valueItem);
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

- (void) setBpm:(NSNumber *)newValue
{
	NSLog(@"Setting %s from %@ to %@","BPM", bpm, newValue);
	bpm = newValue;
	[self setField:BPM value:MP4::Item([newValue intValue])];
}

- (void) setTrack:(NSNumber *)newValue
{
	NSLog(@"Setting %s from %@ to %@","Track#", track, newValue);
	track = newValue;
	[self setField:TRACK_NUMBER value:MP4::Item([newValue intValue], [totalTracks intValue])];
}

- (void) setTotalTracks:(NSNumber *)newValue
{
	NSLog(@"Setting %s from %@ to %@","Total Tracks", totalTracks, newValue);
	totalTracks = newValue;
	[self setField:TRACK_NUMBER value:MP4::Item([track intValue], [newValue intValue])];
}

- (void) setDisk:(NSNumber *)newValue
{
	NSLog(@"Setting %s from %@ to %@","Disk#", disk, newValue);
	disk = newValue;
	[self setField:DISK_NUMBER value:MP4::Item([newValue intValue], [totalDisks intValue])];
}

- (void) setTotalDisks:(NSNumber *)newValue
{
	NSLog(@"Setting %s from %@ to %@","Total Disks", totalDisks, newValue);
	totalDisks = newValue;
	[self setField:DISK_NUMBER value:MP4::Item([disk intValue], [newValue intValue])];
}

- (void) setComplication:(NSNumber *)newValue
{
	NSLog(@"Setting %s from %@ to %@","Complication", complication, newValue);
	complication = newValue;
	[self setField:COMPILATION value:MP4::Item([newValue boolValue] )];
}


@end
