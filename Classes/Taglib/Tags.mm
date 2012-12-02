//
//  TabLibOC.mm
//  Tagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "Tags.h"
#import "TagStructs.h"
#import "NSString+Convert.h"
#import "NSString+Tag.h"
#import "NSNumber+compare.h"

#include <tag.h>

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_ERROR);

static const NSSet *tokensSet;

@interface Tags() // private methdods
// Format the key nicely 
-(NSString*)formatKey:(NSString*)key;
@end

using namespace TagLib;
@implementation Tags
@synthesize title, artist, album, comment, genre, year, track;
@synthesize albumArtist, composer, grouping, bpm, totalTracks, disc, totalDiscs, compilation, url, cover;
@synthesize length, bitrate, channels, sampleRate, kind;
@synthesize albumSort, artistSort, titleSort, composerSort, albumArtistSort;

#pragma mark -
#pragma mark Init

+ (void) initialize
{
	tokensSet = [[NSSet alloc ] initWithObjects:
				 @"title",  @"album",  @"artist", @"composer", @"year",
				 @"track",  @"disc",   @"genre",  @"albumArtist",
				 nil];
}


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
	artist  = [[NSString  alloc] initWithTagString:t->artist() ];
	album   = [[NSString  alloc] initWithTagString:t->album()  ];
	comment = [[NSString  alloc] initWithTagString:t->comment()];
	genre   = [[NSString  alloc] initWithTagString:t->genre()  ];
	
	int i = t->year();
	year    =  i ? [NSNumber numberWithUnsignedInt:i] :nil;
	i = t->track();
	track   =  i ? [NSNumber numberWithUnsignedInt:i] :nil;
	
	
	length     = [NSNumber numberWithInt: data->file->audioProperties()->length()];
	sampleRate = [NSNumber numberWithInt: data->file->audioProperties()->sampleRate()];
	bitrate    = [NSNumber numberWithInt: data->file->audioProperties()->bitrate()];
	channels   = [NSNumber numberWithInt: data->file->audioProperties()->channels()];

}


- (void)dealloc
{
	delete data;
}


#pragma mark -
#pragma mark Misc

- (NSComparisonResult)compare:(Tags *)otherTag
{
	NSComparisonResult res = [self.album compare:otherTag.album];
	if (res == NSOrderedSame) res = [self.disc compareMaybeNill:otherTag.disc]; 
	if (res == NSOrderedSame) res = [self.track compareMaybeNill:otherTag.track];
//	if (res == NSOrderedSame) res = [self.length compare:otherTag.length];
	return res;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", super.description, [self displayName]];
}

- (NSString*) displayName
{
	return [NSString stringWithFormat:@"%@-%@ by %@", self.track, self.title, self.artist];
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
-(void) setCompilation:(NSNumber *)newValue{}

-(void) setUrl:(NSString *)newText{}
-(void) setCover:(NSImage*)newValue{}

- (void)setAlbumSort: (NSString *)newValue {}
- (void)setArtistSort:(NSString *)newValue {}
- (void)setTitleSort: (NSString *)newValue {}

- (void)setComposerSort:   (NSString *)newValue {}
- (void)setAlbumArtistSort:(NSString *)newValue {}


- (void) removeAllTags { DDLogInfo(@"removing tags");}

-(NSString*)formatKey:(NSString*)key
{
	if ([key isEqualToString:@"track"]){
		return [NSString stringWithFormat:@"%02d", [self.track intValue]];
	}else{
		return [self valueForKey:key];
	}
}

-(NSString*)filenameFromFormatArray:(NSArray*)formatStrings
{
	DDLogInfo(@"renaming %@", title);
	NSMutableString *res = [[NSMutableString alloc] init];
	for (NSString *s in formatStrings) {
		if ([tokensSet containsObject:s]){
			[res appendFormat:@"%@", [self formatKey:s]];
		}else{
			[res appendString: s];
		}
	}
	return res;
}

@end
