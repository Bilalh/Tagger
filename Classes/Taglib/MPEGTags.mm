//
//  MP3Tags.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 19/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "MPEGTags.h"
#import "TagStructs.h"
#import "NSString+Convert.h"
#import "NSImage+bitmapData.h"
#include "TagPrivate.h"
#include "Fields.h"

#include <mpegfile.h>
#include <id3v2tag.h> 
#include <id3v2frame.h>
#include <textidentificationframe.h>
#include <attachedPictureFrame.h>
#include <commentsframe.h>

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_ERROR);


@interface MPEGTags()
- (NSString*) getFieldWithString:(const char*)field;
- (bool) setFieldWithString:(const char*)field
					  value:(NSString *)newValue; 

- (void) setNumberPair:(const char *)field
			firstValue:(NSNumber*)firstValue
		   secondValue:(NSNumber*)secondValue;

- (BOOL) removeAllImagesMP3:(TagLib::ID3v2::Tag*) tag
					 ofType:(TagLib::ID3v2::AttachedPictureFrame::Type) imageType;
- (BOOL) removeAllImagesMP3:(TagLib::ID3v2::Tag*) tag;
- (void) initCover;
@end

using namespace TagLib;
using namespace Fields::MPEG;
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
		kind = @"MP3";
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
	
	temp        = [self getFieldWithString:COMPILATION];
	compilation = [NSNumber numberWithBool: temp ? YES : NO];
	
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

	temp  = [self getFieldWithString:DISC_NUMBER];
	if (temp){
		range = [temp rangeOfString:@"/" options:NSLiteralSearch];
		
		if(range.location != NSNotFound && range.length != 0) {
			int i = [[temp substringToIndex:range.location] intValue];
			disc        = i == 0 ? nil : [NSNumber numberWithInt:  i];
			i = [[temp substringFromIndex:range.location+1] intValue];
			totalDiscs	= i == 0 ? nil : [NSNumber numberWithInt:  i];
		}else{
			disc       = nil;
			totalDiscs = nil;
		}	
	}	
	
	url = [self getFieldWithString:URL];
	
	
	// Sort by
	
	albumSort  = [self getFieldWithString:ALBUM_SORT];
	artistSort = [self getFieldWithString:ARTIST_SORT];
	titleSort  = [self getFieldWithString:TITLE_SORT];
	
	composerSort    = [self getFieldWithString:COMPOSER_SORT];
	albumArtistSort = [self getFieldWithString:ALBUM_ARTIST_SORT];

	
	[self initCover];
}

- (void) initCover
{
	const ID3v2::Tag *tag = data->f->mpeg->ID3v2Tag();
	ID3v2::FrameList listOfMp3Frames = tag->frameListMap()[COVER];
	if (!listOfMp3Frames.isEmpty()){
		ID3v2::AttachedPictureFrame *picture = static_cast<ID3v2::AttachedPictureFrame *>(listOfMp3Frames.front());
		if (picture){
			TagLib::ByteVector bv = picture->picture();
			cover = [[[NSImage alloc] initWithData: [NSData dataWithBytes:bv.data() length:bv.size()]] autorelease];	
		}
	}
}

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
					   value:(NSString *)newValue
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
	
	[self setFieldWithString:field value:text];		
}

#pragma mark -
#pragma mark Setters

- (void) removeAllTags
{
	data->f->mpeg->strip(MPEG::File::ID3v1);
	data->f->mpeg->save(MPEG::File::NoTags, true);
}

- (void) setBpm:(NSNumber *)newValue
{
	TAG_SETTER_START(bpm);
	[self setFieldWithString:BPM value:[newValue stringValue]];	
}

- (void) setCompilation:(NSNumber *)newValue
{
	TAG_SETTER_START(compilation);
	[self setFieldWithString:COMPILATION value:[newValue boolValue] ? @"1" : nil ];		
}

- (void) setTrack:(NSNumber *)newValue
{
	TAG_SETTER_START(track);
	[self setNumberPair:TRACK_NUMBER firstValue:track secondValue:totalTracks];
}

- (void) setTotalTracks:(NSNumber *)newValue
{
	TAG_SETTER_START(totalTracks);
	[self setNumberPair:TRACK_NUMBER firstValue:track secondValue:totalTracks];
}

- (void) setDisc:(NSNumber *)newValue
{
	TAG_SETTER_START(disc);
	[self setNumberPair:DISC_NUMBER firstValue:disc secondValue:totalDiscs];
}

- (void) setTotalDiscs:(NSNumber *)newValue
{
	TAG_SETTER_START(totalDiscs);
	[self setNumberPair:DISC_NUMBER firstValue:disc secondValue:totalDiscs];
}


- (void) setAlbumArtist:(NSString*)newValue
{
	TAG_SETTER_START(albumArtist);
	[self setFieldWithString:ALBUM_ARTIST value:newValue];
}

- (void) setComposer:(NSString*)newValue
{
	TAG_SETTER_START(composer);
	[self setFieldWithString:COMPOSER value:newValue];
}

- (void) setGrouping:(NSString*)newValue
{
	TAG_SETTER_START(grouping);
	[self setFieldWithString:GROUPING value:newValue];
}

- (void) setMusicbrainzArtistid:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzArtistid);
	[self setFieldWithString:MUSICBRAINZ_ARTISTID value:newValue];
}

- (void) setMusicbrainzReleaseid:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzReleaseid);
	[self setFieldWithString:MUSICBRAINZ_RELEASEID value:newValue];
}

- (void) setMusicbrainzReleaseArtistid:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzReleaseArtistid);
	[self setFieldWithString:MUSICBRAINZ_RELEASE_ARTISTID value:newValue];
}

- (void) setMusicbrainzTrackId:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzTrackId);
	[self setFieldWithString:MUSICBRAINZ_TRACK_ID value:newValue];
}

- (void) setMusicbrainzDiscId:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzDiscId);
	[self setFieldWithString:MUSICBRAINZ_DISC_ID value:newValue];
}

- (void) setMusicipId:(NSString*)newValue
{
	TAG_SETTER_START(musicipId);
	[self setFieldWithString:MUSICIP_ID value:newValue];
}

- (void) setAmazonId:(NSString*)newValue
{
	TAG_SETTER_START(amazonId);
	[self setFieldWithString:AMAZON_ID value:newValue];
}

- (void) setMusicbrainzReleaseStatus:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzReleaseStatus);
	[self setFieldWithString:MUSICBRAINZ_RELEASE_STATUS value:newValue];
}

- (void) setMusicbrainzReleaseType:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzReleaseType);
	[self setFieldWithString:MUSICBRAINZ_RELEASE_TYPE value:newValue];
}

- (void) setMusicbrainzReleaseCountry:(NSString*)newValue
{
	TAG_SETTER_START(musicbrainzReleaseCountry);
	[self setFieldWithString:MUSICBRAINZ_RELEASE_COUNTRY value:newValue];
}

- (void) setLyrics:(NSString*)newValue
{
	TAG_SETTER_START(lyrics);
	[self setFieldWithString:LYRICS value:newValue];
}

- (void) setArtistSort:(NSString*)newValue
{
	TAG_SETTER_START(artistSort);
	[self setFieldWithString:ARTIST_SORT value:newValue];
}

- (void) setAlbumArtistSort:(NSString*)newValue
{
	TAG_SETTER_START(albumArtistSort);
	[self setFieldWithString:ALBUM_ARTIST_SORT value:newValue];
}

- (void) setAlbumSort:(NSString*)newValue
{
	TAG_SETTER_START(albumSort);
	[self setFieldWithString:ALBUM_SORT value:newValue];
}

- (void) setTitleSort:(NSString*)newValue
{
	TAG_SETTER_START(titleSort);
	[self setFieldWithString:TITLE_SORT value:newValue];
}

- (void) setComposerSort:(NSString*)newValue
{
	TAG_SETTER_START(composerSort);
	[self setFieldWithString:COMPOSER_SORT value:newValue];
}

- (void) setEncoder:(NSString*)newValue
{
	TAG_SETTER_START(encoder);
	[self setFieldWithString:ENCODER value:newValue];
}

- (void) setIsrc:(NSString*)newValue
{
	TAG_SETTER_START(isrc);
	[self setFieldWithString:ISRC value:newValue];
}

- (void) setBarcode:(NSString*)newValue
{
	TAG_SETTER_START(barcode);
	[self setFieldWithString:BARCODE value:newValue];
}

- (void) setCatalogNo:(NSString*)newValue
{
	TAG_SETTER_START(catalogNo);
	[self setFieldWithString:CATALOG_NO value:newValue];
}

- (void) setRecordLabel:(NSString*)newValue
{
	TAG_SETTER_START(recordLabel);
	[self setFieldWithString:RECORD_LABEL value:newValue];
}

- (void) setLyricist:(NSString*)newValue
{
	TAG_SETTER_START(lyricist);
	[self setFieldWithString:LYRICIST value:newValue];
}

- (void) setConductor:(NSString*)newValue
{
	TAG_SETTER_START(conductor);
	[self setFieldWithString:CONDUCTOR value:newValue];
}

- (void) setRemixer:(NSString*)newValue
{
	TAG_SETTER_START(remixer);
	[self setFieldWithString:REMIXER value:newValue];
}

- (void) setMood:(NSString*)newValue
{
	TAG_SETTER_START(mood);
	[self setFieldWithString:MOOD value:newValue];
}

- (void) setMedia:(NSString*)newValue
{
	TAG_SETTER_START(media);
	[self setFieldWithString:MEDIA value:newValue];
}

- (void) setUrl:(NSString*)newValue
{
	TAG_SETTER_START(url);
	[self setFieldWithString:URL value:newValue];
}

- (void) setDiscogsReleaseSiteUrl:(NSString*)newValue
{
	TAG_SETTER_START(discogsReleaseSiteUrl);
	[self setFieldWithString:DISCOGS_RELEASE_SITE_URL value:newValue];
}

- (void) setWikipediaReleaseSiteUrl:(NSString*)newValue
{
	TAG_SETTER_START(wikipediaReleaseSiteUrl);
	[self setFieldWithString:WIKIPEDIA_RELEASE_SITE_URL value:newValue];
}

- (void) setOfficialArtistSiteUrl:(NSString*)newValue
{
	TAG_SETTER_START(officialArtistSiteUrl);
	[self setFieldWithString:OFFICIAL_ARTIST_SITE_URL value:newValue];
}

- (void) setDiscogsArtistSiteUrl:(NSString*)newValue
{
	TAG_SETTER_START(discogsArtistSiteUrl);
	[self setFieldWithString:DISCOGS_ARTIST_SITE_URL value:newValue];
}

- (void) setWikipediaArtistSiteUrl:(NSString*)newValue
{
	TAG_SETTER_START(wikipediaArtistSiteUrl);
	[self setFieldWithString:WIKIPEDIA_ARTIST_SITE_URL value:newValue];
}

- (void) setLanguage:(NSString*)newValue
{
	TAG_SETTER_START(language);
	[self setFieldWithString:LANGUAGE value:newValue];
}

- (void) setLyricsSiteUrl:(NSString*)newValue
{
	TAG_SETTER_START(lyricsSiteUrl);
	[self setFieldWithString:LYRICS_SITE_URL value:newValue];
}



#pragma mark - Cover and Comment

- (void) setComment:(NSString *)newValue
{
	TAG_SETTER_START(comment);
	(TagLib::ID3v2::FrameFactory::instance())->setDefaultTextEncoding(TagLib::String::UTF8);
	ID3v2::Tag *tag = data->f->mpeg->ID3v2Tag();	
	tag->removeFrames("COMM");
	if(nil != newValue) {
		ID3v2::CommentsFrame *frame =  new ID3v2::CommentsFrame();
		frame->setText([newValue tagLibString]);
		frame->setLanguage("eng");
		tag->addFrame(frame);
	}
	data->file->save();
}


// need fixing for vbr?
- (void) setCover:(NSImage *)newValue
{
	TAG_SETTER_START(cover);
	
	ID3v2::Tag *tag = data->f->mpeg->ID3v2Tag();
	tag->removeFrames(COVER);
	data->f->mpeg->save();
	if (cover){
	
		ID3v2::AttachedPictureFrame *frame = new TagLib::ID3v2::AttachedPictureFrame;
		frame->setMimeType("image/jpeg");		

		ID3v2::AttachedPictureFrame::Type type =ID3v2::AttachedPictureFrame::FrontCover;
		frame->setType(type);

		NSData *imageData = [cover bitmapDataForType:NSJPEGFileType];
		frame->setPicture(ByteVector((const char *)[imageData bytes], (uint)[imageData length]));	
		
		tag->addFrame(frame);

	}	
	data->f->mpeg->save();
	
//	Needed otherwise replacing the cover again does not work
	[self initCover];
}

// Unused
- (BOOL) removeAllImagesMP3:(TagLib::ID3v2::Tag*) tag
{
	if (tag) {
		TagLib::ID3v2::FrameList frameList= tag->frameList("APIC");
		if (!frameList.isEmpty()){
			std::list<TagLib::ID3v2::Frame*>::const_iterator iter = frameList.begin();
			while (iter != frameList.end()) {
				std::list<TagLib::ID3v2::Frame*>::const_iterator nextIter = iter;
				nextIter++;
				tag->removeFrame(*iter);
				iter = nextIter;
			}
		}
	}
	
	return YES;
}

// Unused
- (BOOL) removeAllImagesMP3:(TagLib::ID3v2::Tag*) tag
					 ofType:(TagLib::ID3v2::AttachedPictureFrame::Type) imageType
{
	if (tag) {
		TagLib::ID3v2::FrameList frameList= tag->frameList("APIC");
		if (!frameList.isEmpty()){
			std::list<TagLib::ID3v2::Frame*>::const_iterator iter = frameList.begin();
			while (iter != frameList.end()) {
				TagLib::ID3v2::AttachedPictureFrame *frame =
				static_cast<TagLib::ID3v2::AttachedPictureFrame *>( *iter );
				std::list<TagLib::ID3v2::Frame*>::const_iterator nextIter = iter;
				nextIter++;
				if (frame && frame->type() == imageType){
					tag->removeFrame(*iter);
				}
				iter = nextIter;
			}
		}
	}
	
	return YES;
}


@end
