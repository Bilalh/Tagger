//
//  FileSystemCollection.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "FileSystemNodeCollection.h"
#import "FileSystemNode.h"
#import "Tags.h"

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface FileSystemNodeCollection()
-(void) initfields;
-(void) nilAllFields;
@end

@implementation FileSystemNodeCollection
@synthesize tagsArray, hasBasicMetadata, hasExtenedMetadata;
@synthesize title, artist, album, comment, genre, year, track, length;
@synthesize albumArtist, composer, grouping, bpm, totalTracks, disc, totalDiscs, compilation, url, cover;

#pragma mark -
#pragma mark Init

- (id)init
{
    self = [super init];
    if (self) {
		fieldNames = [[NSArray alloc] initWithObjects:
		 @"title", @"album" ,
		 @"artist", @"albumArtist",
		 @"genre", @"grouping",
		 @"track", @"totalTracks",
		 @"disc",  @"totalDiscs" ,
		 @"compilation", @"year",
		 @"composer", @"bpm",
		 @"comment", @"cover",
		 nil];
    }
	
    return self;
}



-(void) initfields
{
	writeToAll = false;
	const Tags *tags= [[tagsArray objectAtIndex:0] tags];
	for (NSString *s in fieldNames) {
		[self setValue:[tags valueForKey:s] forKey:s];
	}
	
	for (FileSystemNode *n in tagsArray) {
		const Tags *tags = n.tags;
		
		for (NSString *key in fieldNames) {
			id mine = [self valueForKey:key];
			if (!mine) continue;
			if ([[tags valueForKey:key] isNotEqualTo:mine]){
				[self setValue:nil forKey:key];
			}
		}
	}
	writeToAll = true;
}

#pragma mark -
#pragma mark General

-(NSError*) renameWithFormatArray:(NSArray*)formatStrings;
{
	NSError *err;
	for (FileSystemNode *n in tagsArray) {
		err = [n filenameFromFormatArray:formatStrings];
		if (err) {
			DDLogError(@"message %@", [err localizedDescription]);
			return err;	
		}
	}
	return err;
}

#pragma mark -
#pragma mark Setters

-(void) nilAllFields
{
	writeToAll = NO;
	hasBasicMetadata = hasExtenedMetadata = NO; 
	for (NSString *key in fieldNames) {
		[self setValue:nil forKey:key];
	}
	writeToAll = YES;
}

/// set the new array and finds the metdata for each tag
-(void) setTagsArray:(NSArray *)newArray
{
	DDLogVerbose(@"newArray %@", newArray);
	tagsArray = newArray;
	if (!tagsArray || [tagsArray count] ==0){
		[self nilAllFields];
		return;
	}
	
	hasExtenedMetadata = hasBasicMetadata = YES;
	
	for (FileSystemNode *n in tagsArray) {
		if (n.isDirectory){
			DDLogInfo(@"dir %@", n);
			[self nilAllFields];
			DDLogInfo(@"%d %d", hasBasicMetadata, hasExtenedMetadata);
			return;
		}
		hasBasicMetadata   &= n.hasBasicMetadata;
		hasExtenedMetadata &= n.hasExtenedMetadata;
	}
	
	DDLogVerbose(@"basic:%d extened %d", hasBasicMetadata, hasExtenedMetadata);
	if (hasBasicMetadata) [self initfields];
	else                  [self nilAllFields];
}

#define SETTER_METHOD_FSN(field,newValue)                                 \
field = newValue;                                                         \
if (!writeToAll) return;                                                  \
DDLogInfo(@"fsnc:%s writeToAll:%d value:%@", #field, writeToAll,newValue);\
for (FileSystemNode *n in tagsArray) {                                    \
	n.tags.field = newValue;                                              \
}                                                                    

-(void) setAlbum:(NSString *)newValue  { SETTER_METHOD_FSN(album,   newValue );}
-(void) setTitle:(NSString *)newValue  { SETTER_METHOD_FSN(title,   newValue );}
-(void) setArtist:(NSString *)newValue { SETTER_METHOD_FSN(artist,  newValue );}
-(void) setComment:(NSString *)newValue{ SETTER_METHOD_FSN(comment, newValue );}
-(void) setGenre:(NSString *)newValue  { SETTER_METHOD_FSN(genre,   newValue );}

-(void) setYear:(NSNumber*)newValue    { SETTER_METHOD_FSN(year,    newValue );}
-(void) setTrack:(NSNumber*)newValue   { SETTER_METHOD_FSN(track,   newValue );}
-(void) setBpm:(NSNumber *)newValue    { SETTER_METHOD_FSN(bpm,     newValue );}
-(void) setDisc:(NSNumber *)newValue   { SETTER_METHOD_FSN(disc,    newValue );}
-(void) setCover:(NSImage *)newValue   { SETTER_METHOD_FSN(cover,   newValue );}


-(void) setAlbumArtist:(NSString *)newValue { SETTER_METHOD_FSN(albumArtist, newValue );}
-(void) setComposer:(NSString *)newValue    { SETTER_METHOD_FSN(composer,    newValue );}
-(void) setGrouping:(NSString *)newValue    { SETTER_METHOD_FSN(grouping,    newValue );}

-(void) setTotalTracks:(NSNumber *)newValue { SETTER_METHOD_FSN(totalTracks, newValue );}
-(void) setTotalDiscs:(NSNumber *)newValue  { SETTER_METHOD_FSN(totalDiscs,  newValue );}
-(void) setCompilation:(NSNumber *)newValue { SETTER_METHOD_FSN(compilation, newValue );}


@end

