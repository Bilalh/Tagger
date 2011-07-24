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
#import "Fields.h"

#include <mp4tag.h> 
#include <mp4file.h>

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface MP4Tags()
- (NSString*) getFieldWithString:(TagLib::String)field;
- (TagLib::MP4::Item) getField:(TagLib::String)field;
- (bool) setFieldWithString:(TagLib::String)field
					  value:(NSString*)value;
@end

using namespace TagLib;
using namespace MP4Fields;
using namespace std;
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
	const MP4::Item::IntPair discs  = [self getField:DISK_NUMBER].toIntPair();
	int i;
	
	albumArtist  = [self getFieldWithString:ALBUM_ARTIST];
	composer     = [self getFieldWithString:COMPOSER];
	grouping     = [self getFieldWithString:GROUPING];
	complication = [NSNumber numberWithBool:[self getField:COMPILATION].toBool()];
	i            = [self getField:BPM].toInt();
	bpm          = i ?  [NSNumber numberWithInt: i] : nil;
	
	disc         = discs.first   ? [NSNumber numberWithInt:discs.first]   : nil;
	totalDiscs   = discs.second  ? [NSNumber numberWithInt:discs.second]  : nil;
	totalTracks  = tracks.second ? [NSNumber numberWithInt:tracks.second] : nil;
	
	
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
	DDLogInfo(@"Setting %s from %@ to %@","Album Artist", albumArtist, newValue);
	albumArtist = newValue;
	[self setFieldWithString:ALBUM_ARTIST  value:newValue]; 
}

- (void) setComposer:(NSString *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@", "Composer", composer, newValue);
	composer = newValue;
	[self setFieldWithString:COMPOSER  value:newValue]; 
}

- (void) setGrouping:(NSString *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Grouping", grouping, newValue);
	grouping = newValue;
	[self setFieldWithString:GROUPING  value:newValue]; 
}

- (void) setBpm:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","BPM", bpm, newValue);
	bpm = newValue;
	[self setField:BPM value:  MP4::Item([newValue intValue])];
}

- (void) setTrack:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Track#", track, newValue);
	track = newValue;
	[self setField:TRACK_NUMBER value:MP4::Item([newValue intValue], [totalTracks intValue])];
}

- (void) setTotalTracks:(NSNumber *)newValue
{
	
	DDLogInfo(@"Setting %s from %@ to %@","Total Tracks", totalTracks, newValue);
	totalTracks = newValue;
	[self setField:TRACK_NUMBER value:MP4::Item([track intValue], [newValue intValue])];
}

- (void) setDisc:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Disc#", disc, newValue);
	disc = newValue;
	[self setField:DISK_NUMBER value:MP4::Item([newValue intValue], [totalDiscs intValue])];
}

- (void) setTotalDiscs:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Total Discs", totalDiscs, newValue);
	totalDiscs = newValue;
	[self setField:DISK_NUMBER value:MP4::Item([disc intValue], [newValue intValue])];
}

- (void) setComplication:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Complication", complication, newValue);
	complication = newValue;
	[self setField:COMPILATION value:MP4::Item([newValue boolValue] )];
}

@end
