//
//  MP3Tags.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 19/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MPEGTags.h"
#import "TagStructs.h"
#import "NSString+Convert.h"

#include <mpegfile.h>
#include <id3v2tag.h> 
#include <textidentificationframe.h>

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

namespace MPEGFields {	// can not be put in the header for some reason
	const char *ALBUM_ARTIST = "TPE2";
	const char *COMPOSER     = "TCOM";
	const char *GROUPING     = "TIT1";
	
	const char *COMPILATION  = "TCMP";
	const char *BPM          = "TBPM";
	
	const char *TRACK_NUMBER = "TRCK";
	const char *TOTAL_TRACKS = "TRCK";
	const char *DISK_NUMBER  = "TPOS";
	const char *TOTAL_DISKS  = "TPOS";
	
	const char *ENCODER      = "TENC";
	const char *COVER        = "APIC";
}

@interface MPEGTags()
- (NSString*) getFieldWithString:(const char*)field;
- (void) setNumberPair:(const char *)field
			firstValue:(NSNumber*)firstValue
		   secondValue:(NSNumber*)secondValue;
@end

using namespace TagLib;
using namespace MPEGFields;
@implementation MPEGTags

#pragma mark -
#pragma mark init/alloc

- (id) initWithFilename:(NSString *)filename
{
    self = [super initWithFilename:filename];
    if (self) {
		data->f->mpeg = new MPEG::File([filename UTF8String]);
		data->file = data->f->mpeg;
		[self initFields];
    }
    
    return self;	
}

-(void) initFields
{	
	[super initFields];
	NSString *temp = nil;
	NSRange   range;
	
	albumArtist = [self getFieldWithString:ALBUM_ARTIST];
	composer    = [self getFieldWithString:COMPOSER];
	grouping    = [self getFieldWithString:GROUPING];
	
	temp        = [self getFieldWithString:BPM];
	bpm         = temp ? [NSNumber numberWithInt:[temp intValue]] : nil;
	
	temp         = [self getFieldWithString:COMPILATION];
	complication = [NSNumber numberWithBool: temp ? YES : NO];
	
	temp  = [self getFieldWithString:TRACK_NUMBER];
	if (temp){
		range = [temp rangeOfString:@"/" options:NSLiteralSearch];
		
		if(range.location != NSNotFound && range.length != 0) {
			int i = [[temp substringFromIndex:range.location+1] intValue];
			totalTracks	=  i == 0 ? nil : [NSNumber numberWithInt:  i];
		}else{
			totalTracks = nil;
		}	
	}

	temp  = [self getFieldWithString:DISK_NUMBER];
	if (temp){
		range = [temp rangeOfString:@"/" options:NSLiteralSearch];
		
		if(range.location != NSNotFound && range.length != 0) {
			int i = [[temp substringToIndex:range.location] intValue];
			disk        = i == 0 ? nil : [NSNumber numberWithInt:  i];
			i = [[temp substringFromIndex:range.location+1] intValue];
			totalDisks	= i == 0 ? nil : [NSNumber numberWithInt:  i];
		}else{
			disk       = nil;
			totalDisks = nil;
		}	
	}	
}

//TODO
//complication = [NSNumber numberWithBool:[self getField:COMPILATION].toBool()];

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Fields helpers

- (NSString*) getFieldWithString:(const char*)field
{
	const ID3v2::Tag *tag = data->f->mpeg->ID3v2Tag();
	TagLib::ID3v2::FrameList l = tag->frameList(field);
	return l.isEmpty() ? nil : [[NSString  alloc] initWithTagString:l.front()->toString()];
}


- (bool) setFieldWithString:(const char*)field
					   data:(NSString *)newValue
{
	DDLogVerbose(@"%s '%@'", field, newValue);
	(TagLib::ID3v2::FrameFactory::instance())->setDefaultTextEncoding(TagLib::String::UTF8);
	ID3v2::Tag *tag = data->f->mpeg->ID3v2Tag();	
	tag->removeFrames(field);
	//  Total tracks on it own does not work without this
	data->f->mpeg->strip(MPEG::File::ID3v1);
	if(nil != newValue) {
		ID3v2::TextIdentificationFrame *frame = new ID3v2::TextIdentificationFrame(field, TagLib::String::UTF8);
		frame->setText([newValue tagLibString]);
		tag->addFrame(frame);
	}
	return data->file->save();
}

- (void) setNumberPair:(const char *)field
			firstValue:(NSNumber*)firstValue
		   secondValue:(NSNumber*)secondValue
{
	NSString *text = nil;
	if (firstValue != nil && secondValue != nil){
		text = [[NSString alloc] initWithFormat:@"%@/%@",firstValue, secondValue];
		DDLogVerbose(@"1 %@",text);
	}else if (firstValue != nil){
		text = [[NSString alloc] initWithFormat:@"%@/",firstValue];
		DDLogVerbose(@"2 %@",text);
	}else if (secondValue != nil){
		text = [[NSString alloc] initWithFormat:@"/%@",secondValue];
		DDLogVerbose(@"3 %@",text);
	}
	
	[self setFieldWithString:field data:text];		
}

#pragma mark -
#pragma mark Setters

- (void) setAlbumArtist:(NSString *)newValue
{ 
	DDLogInfo(@"Setting %s from %@ to %@","Album Artist", albumArtist, newValue);
	albumArtist = newValue;
	[self setFieldWithString:ALBUM_ARTIST data:newValue];
}

- (void) setComposer:(NSString *)newValue
{ 
	DDLogInfo(@"Setting %s from %@ to %@","Composer", composer, newValue);
	composer = newValue;
	[self setFieldWithString:COMPOSER data:newValue];
}

- (void) setGrouping:(NSString *)newValue
{ 
	DDLogInfo(@"Setting %s from %@ to %@","Composer", grouping, newValue);
	grouping = newValue;
	[self setFieldWithString:GROUPING data:newValue];
}

- (void) setBpm:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Bpm", bpm, newValue);
	bpm = newValue;
	[self setFieldWithString:BPM data:[newValue stringValue]];	
}

- (void) setComplication:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Complication", complication, newValue);
	complication = newValue;
	[self setFieldWithString:COMPILATION data:[newValue boolValue] ? @"1" : nil ];		
}

- (void) setTrack:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Track#", track, newValue);
	track = newValue;
	[self setNumberPair:TRACK_NUMBER firstValue:track secondValue:totalTracks];
}

- (void) setTotalTracks:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Total Tracks", totalTracks, newValue);
	totalTracks = newValue;
	[self setNumberPair:TRACK_NUMBER firstValue:track secondValue:totalTracks];
}

- (void) setDisk:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Disk#", disk, newValue);
	disk = newValue;
	[self setNumberPair:DISK_NUMBER firstValue:disk secondValue:totalDisks];
}

- (void) setTotalDisks:(NSNumber *)newValue
{
	DDLogInfo(@"Setting %s from %@ to %@","Total Disks", totalDisks, newValue);
	totalDisks = newValue;
	[self setNumberPair:DISK_NUMBER firstValue:disk secondValue:totalDisks];
}

@end
