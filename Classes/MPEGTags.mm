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
	
	temp = [self getFieldWithString:TRACK_NUMBER];
	range			= [temp rangeOfString:@"/" options:NSLiteralSearch];
	
	if(range.location != NSNotFound && range.length != 0) {
		totalTracks	=  [NSNumber numberWithInt: [[temp substringFromIndex:range.location + 1] intValue] ];
	}else{
		totalTracks = nil;
	}
	
}

//TODO
//complication = [NSNumber numberWithBool:[self getField:COMPILATION].toBool()];
//
//disk         = disks.first   ? [NSNumber numberWithInt:disks.first]   : nil;
//totalDisks   = disks.second  ? [NSNumber numberWithInt:disks.second]  : nil;
//totalTracks  = tracks.second ? [NSNumber numberWithInt:tracks.second] : nil;


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
	(TagLib::ID3v2::FrameFactory::instance())->setDefaultTextEncoding(TagLib::String::UTF8);
	ID3v2::Tag *tag = data->f->mpeg->ID3v2Tag();	
	tag->removeFrames(field);
	if(nil != newValue) {
		ID3v2::TextIdentificationFrame *frame = new ID3v2::TextIdentificationFrame(field, TagLib::String::UTF8);
		frame->setText([newValue tagLibString]);
		tag->addFrame(frame);
	}
	return data->file->save();
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


@end
