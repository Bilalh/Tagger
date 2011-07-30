//
//  TabLibOC.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "Tags.h"
#import "TagStructs.h"
#import "NSString+Convert.h"

#include "TagConverter.h"
#include <tag.h>

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface Tags() // private methdods
#pragma mark private
@end
#pragma mark -

using namespace TagLib;
@implementation Tags
@synthesize title, artist, album, comment, genre, year, track, length;
@synthesize albumArtist, composer, grouping, bpm, totalTracks, disc, totalDiscs, complication, url, cover;

#pragma mark -
#pragma mark Init

- (id) init
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id) initWithFilename:(NSString *)filename
{
	self = [super init];
	if(self) {
		if(filename == nil) {
			[self release];
			return nil;
		} else {
			data = new FileData;
			data->f = new FileDetails;
		}
	}
	
	return self;
}


- (void) initFields
{
	const Tag *t = data->file->tag();
	title   = [[NSString  alloc] initWithTagString:t->title()  ];
	title   = [[NSString  alloc] initWithTagString:t->title()  ];
	artist  = [[NSString  alloc] initWithTagString:t->artist() ];
	album   = [[NSString  alloc] initWithTagString:t->album()  ];
	comment = [[NSString  alloc] initWithTagString:t->comment()];
	genre   = [[NSString  alloc] initWithTagString:t->genre()  ];
	
	int i = t->year();
	year    =  i ? [NSNumber numberWithUnsignedInt:i] :nil;
	i = t->track();
	track   = i ? [NSNumber numberWithUnsignedInt:i] :nil;
	
	length = [NSNumber numberWithInt: data->file->audioProperties()->length()];
	
}


- (void)dealloc
{
    [super dealloc];
	delete data;
}


#pragma mark -
#pragma mark Misc

- (NSComparisonResult)compare:(Tags *)otherTag
{
	NSComparisonResult res = [self.album compare:otherTag.album];
	if (res == NSOrderedSame) res = [self.disc compare:otherTag.disc]; 
	if (res == NSOrderedSame) res = [self.track compare:otherTag.track];
//	if (res == NSOrderedSame) res = [self.length compare:otherTag.length];
	return res;
}



#pragma mark -
#pragma mark Setters

// Saves the newData to file

#define setMetadata(newText,field,saveFunction)                  \
if ([field isEqualTo:newText]) return;                           \
DDLogInfo(@"Setting "#field" from %@ to %@",field, newText);     \
field = newText;                                                 \
Tag * const t = data->file->tag();                               \
t->saveFunction (field ? [ field tagLibString] : String::null ); \
bool b =data->file->save();                                      \
DDLogInfo(@"res:%d "#field":%s", b, t->field().toCString() );

#define setNumberMetadata(newNumber,field,saveFunction)        \
if ([field isEqualTo:newNumber]) return;                       \
DDLogInfo(@"Setting "#field" from %@ to %@",field, newNumber); \
field = newNumber;                                             \
Tag * const t = data->file->tag();                             \
t->saveFunction (field ? [field unsignedIntValue] :0 );        \
bool b =data->file->save();                                    \
DDLogInfo(@"res:%d "#field":%u", b, t->field());               


-(void) setTitle:(NSString *)newText  { setMetadata(newText,title,setTitle); }
-(void) setArtist:(NSString *)newText { setMetadata(newText,artist,setArtist); }
-(void) setAlbum:(NSString *)newText  { setMetadata(newText,album,setAlbum); }
-(void) setComment:(NSString *)newText{ setMetadata(newText,comment,setComment); }
-(void) setGenre:(NSString *)newText  { setMetadata(newText,genre,setGenre); }

-(void) setYear:(NSNumber*)newNumber  { setNumberMetadata(newNumber,year,setYear);}
-(void) setTrack:(NSNumber*)newNumber { setNumberMetadata(newNumber,track,setTrack); }

-(void) setAlbumArtist:(NSString *)newText{}
-(void) setComposer:(NSString *)newText{}
-(void) setGrouping:(NSString *)newText{}

-(void) setBpm:(NSNumber *)newValue{}
-(void) setDisc:(NSNumber *)newValue{}
-(void) setTotalTracks:(NSNumber *)newValue{}
-(void) setTotalDiscs:(NSNumber *)newValue{}
-(void) setComplication:(NSNumber *)newValue{}

-(void) setUrl:(NSString *)newText{}
-(void) setCover:(NSImage *)newText{}

-(NSString*)filenameFromFormat:(NSString*)format
{
	TagConverter tc;
	const TagLib::Tag *t = data->file->tag();
	std::string s = tc.tagToFilename_(*t, *[format cppString]);
	return [[NSString alloc] initWithCppString:&s];
}

@end
