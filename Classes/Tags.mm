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

#include <mp4tag.h> 
#include <mp4file.h>
#include <mpegfile.h>


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
	year    = [NSNumber numberWithUnsignedLong:t->year()];
	track   = [NSNumber numberWithUnsignedLong:t->track()];
}


- (void) setTitle:(NSString*) newText{
	NSLog(@"Abstact class method setTitle");
}


- (void)dealloc
{
    [super dealloc];
	delete data;
}

@end
