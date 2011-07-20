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

#include <tag.h>

@interface Tags() // private methdods
#pragma mark private
@end
#pragma mark -

using namespace TagLib;
@implementation Tags
@synthesize title, artist, album, comment, genre, year, track;

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
	NSLog(@"initFields");
	const Tag *t = data->file->tag();
	title   = [[NSString  alloc] initWithTagString:t->title()  ];
	title   = [[NSString  alloc] initWithTagString:t->title()  ];
	artist  = [[NSString  alloc] initWithTagString:t->artist() ];
	album   = [[NSString  alloc] initWithTagString:t->album()  ];
	comment = [[NSString  alloc] initWithTagString:t->comment()];
	genre   = [[NSString  alloc] initWithTagString:t->genre()  ];
	year    = [NSNumber numberWithUnsignedInt:t->year()];
	track   = [NSNumber numberWithUnsignedInt:t->track()];
}


- (void)dealloc
{
    [super dealloc];
	delete data;
}


#pragma mark -
#pragma mark Setters

// Saves the newData to file

#define setMetadata(newText,field,saveFunction)         \
NSLog(@"Setting "#field" from %@ to %@",field, newText);\
field = newText;                                        \
Tag * const t = data->file->tag();                      \
t->saveFunction ([ field tagLibString]);                \
bool b =data->file->save();                             \
NSLog(@"res:%d "#field":%s", b, t->field().toCString() );

#define setNumberMetadata(newNumber,field,saveFunction)    \
NSLog(@"Setting "#field" from %@ to %@",field, newNumber); \
field = newNumber;                                         \
Tag * const t = data->file->tag();                         \
t->saveFunction ([ field unsignedIntValue]);               \
bool b =data->file->save();                                \
NSLog(@"res:%d "#field":%u", b, t->field());               


-(void) setTitle:(NSString *)newText  { setMetadata(newText,title,setTitle); }
-(void) setArtist:(NSString *)newText { setMetadata(newText,artist,setArtist); }
-(void) setAlbum:(NSString *)newText  { setMetadata(newText,album,setAlbum); }
-(void) setComment:(NSString *)newText{ setMetadata(newText,comment,setComment); }
-(void) setGenre:(NSString *)newText  { setMetadata(newText,genre,setGenre); }

-(void) setYear:(NSNumber*)newNumber  { setNumberMetadata(newNumber,year,setYear);}
-(void) setTrack:(NSNumber*)newNumber { setNumberMetadata(newNumber,track,setTrack); }


@end
