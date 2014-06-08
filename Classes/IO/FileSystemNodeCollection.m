//
//  FileSystemCollection.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "FileSystemNodeCollection.h"
#import "FileSystemNode.h"
#import "Tags.h"
#import "NSImage+bitmapData.h"
#import "MPEGTags.h"
#import "MP4Tags.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);

static const NSArray *tagFieldNames;
static const NSArray *fieldNames;

@interface FileSystemNodeCollection()
- (void)initfields;
- (void)nilAllFields;
- (void)initColor;
@end

@implementation FileSystemNodeCollection
@synthesize tagsArray, hasBasicMetadata, hasExtenedMetadata, allMp3s, allMp4s, containsMP4Files, empty, labelColor, labelIndex;
@synthesize title, artist, album, comment, genre, year, track, length;
@synthesize albumArtist, composer, grouping, bpm, totalTracks, disc, totalDiscs, compilation, url, cover;
@dynamic urls;
@synthesize albumSort, artistSort, titleSort, composerSort, albumArtistSort, isrc,releaseDate;

#pragma mark -
#pragma mark Init

+ (void)initialize
{
	tagFieldNames = @[
				  @"title", @"album" ,
				  @"artist", @"albumArtist",
				  @"genre", @"grouping",
				  @"track", @"totalTracks",
				  @"disc",  @"totalDiscs" ,
				  @"compilation", @"year",
				  @"composer", @"bpm",
				  @"comment", @"cover", @"url",
			      @"artistSort", @"albumSort", @"titleSort",
				  @"composerSort", @"albumArtistSort",
                  @"isrc", @"releaseDate",
				  ];
	fieldNames = [[NSArray alloc] initWithObjects:
				  @"labelColor", @"labelIndex",
				  nil];
					 
}

- (id)init
{
    self = [super init];
    if (self) {
		self.empty = YES;
    }
	
    return self;
}



- (void)initfields
{
	containsMP4Files = false;
	writeToAll = false;
	const Tags *tags0= [[tagsArray objectAtIndex:0] tags];
	for (NSString *s in tagFieldNames) {
		[self setValue:[tags0 valueForKey:s] forKey:s];
	}
	for (NSString *s in fieldNames) {
		[self setValue:[[tagsArray objectAtIndex:0] valueForKey:s] forKey:s];
	}
	
	containsMP4Files = false;
	
	for (FileSystemNode *n in tagsArray) {
		const Tags *tags = n.tags;
		
		for (NSString *key in tagFieldNames) {
			id mine = [self valueForKey:key];
			
			if (mine == NSMultipleValuesMarker) continue;
			
			// Check if the images are equal
			if ([key isEqualToString:@"cover"]){
				NSData *imageData = [[tags valueForKey:key]  bitmapDataForType:NSJPEGFileType];
				if (![imageData isEqualToData:[mine bitmapDataForType:NSJPEGFileType]]){
					[self setValue:NSMultipleValuesMarker forKey:key];
				}
				continue;
			}
			
			if ([[tags valueForKey:key] isNotEqualTo:mine] || (![tags valueForKey:key] && mine ) ){
				[self setValue:NSMultipleValuesMarker forKey:key];
			}
		}
		
		for (NSString *key in fieldNames) {
			id mine = [self valueForKey:key];
			if (mine != NSMultipleValuesMarker) {
				if ([[n valueForKey:key] isNotEqualTo:mine]){
					[self setValue:NSMultipleValuesMarker forKey:key];
				}	
			}			
		}
		if ([tags.kind isEqualToString:@"MP4"]){
			containsMP4Files = true;
		}
	}
	writeToAll = true;
}

- (void) initColor
{
	writeToAll = false;
	for (NSString *s in fieldNames) {
		[self setValue:[[tagsArray objectAtIndex:0] valueForKey:s] forKey:s];
	}
	for (FileSystemNode *n in tagsArray) {
		for (NSString *key in fieldNames) {
			id mine = [self valueForKey:key];
			if (mine != NSMultipleValuesMarker) {
				if ([[n valueForKey:key] isNotEqualTo:mine]){
					[self setValue:NSMultipleValuesMarker forKey:key];
				}	
			}			
		}
	}
	writeToAll = true;
}

#pragma mark -
#pragma mark General

- (NSError*)renameWithFormatArray:(NSArray*)formatStrings;
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

- (NSError*)tagsWithFormatArrayFromFilename:(NSArray*)formatStrings;
{
	NSError *err;
	for (FileSystemNode *n in tagsArray) {
		err = [n tagsWithFormatArrayFromFilename:formatStrings];
		if (err) {
			DDLogError(@"message %@", [err localizedDescription]);
			return err;	
		}
	}
	[self initfields];
	return err;
}

- (void) performBlockOnTag:(NSString*)tagName
					  block:(id (^)(id value, NSString *tagName, Tags *tags ))block
{
	[self performBlockOnTags:[NSArray arrayWithObject:tagName] block:block];
}

- (void) performBlockOnTags:(const NSArray*)tagsNames
					  block:(id (^)(id value, NSString *tagName, Tags *tags ))block
{
	if (!self.hasBasicMetadata) return;
	
	for (FileSystemNode *n in tagsArray) {
		for (NSString *tagName in tagsNames) {
			DDLogVerbose(@"-%@: %@", tagName, [n.tags valueForKey:tagName]);
			[n.tags setValue:block([n.tags valueForKey:tagName], tagName, n.tags)
					  forKey:tagName];
			DDLogVerbose(@"+%@: %@", tagName, [n.tags valueForKey:tagName]);
		}
	}
	
}

- (NSArray*)urls
{
	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[tagsArray count]+1];
	for (FileSystemNode *n in tagsArray) {
		[arr addObject:n.URL];
	}
	return arr;
}

#pragma mark -
#pragma mark Setters

- (void)nilAllFields
{
	writeToAll = NO;
	hasBasicMetadata = hasExtenedMetadata = allMp3s = allMp4s = NO;
	for (NSString *key in tagFieldNames) {
		[self setValue:nil forKey:key];
	}
	writeToAll = YES;
}

- (void)deleteAllTags
{
	for (FileSystemNode *n in tagsArray) {
		[n.tags removeAllTags];
	}
}

- (void)swapFirstAndLastName:(NSString*)key;
{
	for (FileSystemNode *n in tagsArray) {
		[n swapFirstAndLastName:key];
	}
}

- (void)saveMetadata
{
    DDLogInfo(@"saving Metadata for each node");
    for (FileSystemNode *n in tagsArray) {
        if ([n tags]){
            [[n tags] writeMetaData];
        }
	}
    
}

/// set the new array and finds the metdata for each tag
- (void)setTagsArray:(NSArray *)newArray
{
    DDLogInfo(@"TagsArray Changing from \n %@ to \n %@", tagsArray, newArray);
    [self  saveMetadata];
    
	tagsArray = newArray;
	if (!tagsArray || [tagsArray count] ==0){
		[self nilAllFields];
		self.empty = YES;
		return;
	}
	
	self.empty = NO;
	hasExtenedMetadata = hasBasicMetadata = allMp3s = allMp4s = YES;
	
	for (FileSystemNode *n in tagsArray) {
		if (n.isDirectory){
			[self nilAllFields];
			[self initColor];
			return;
		}
		hasBasicMetadata   &= n.hasBasicMetadata;
		hasExtenedMetadata &= n.hasExtenedMetadata;
        allMp3s            &= [n.tags isMemberOfClass:[MPEGTags class]];
        allMp4s            &= [n.tags isMemberOfClass:[MP4Tags class]];

	}
	
	DDLogRelease(@"basic:%d extened %d allmp3s %d allMp4 %d", hasBasicMetadata, hasExtenedMetadata, allMp3s, allMp4s);
	if (hasBasicMetadata) [self initfields];
	else                  [self nilAllFields];
}

#define SETTER_METHOD_FSN(newValue,field)                                 \
field = newValue;                                                         \
if (!writeToAll) return;                                                  \
DDLogInfo(@"fsnc:%s writeToAll:%d value:%@", #field, writeToAll,newValue);\
for (FileSystemNode *n in tagsArray) {                                    \
n.tags.field = newValue;                                              \
}

- (void) setArtist                    :(NSString*)newValue {SETTER_METHOD_FSN(newValue, artist )}
- (void) setAlbum                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, album )}
- (void) setTitle                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, title )}
- (void) setTrack                     :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, track )}
- (void) setYear                      :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, year )}
- (void) setGenre                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, genre )}
- (void) setComment                   :(NSString*)newValue {SETTER_METHOD_FSN(newValue, comment )}
- (void) setAlbumArtist               :(NSString*)newValue {SETTER_METHOD_FSN(newValue, albumArtist )}
- (void) setComposer                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, composer )}
- (void) setGrouping                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, grouping )}
- (void) setDisc                      :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, disc )}
- (void) setCover                     :(NSImage*)newValue  {SETTER_METHOD_FSN(newValue, cover )}
- (void) setBpm                       :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, bpm )}
- (void) setCompilation               :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, compilation )}
- (void) setArtistSort                :(NSString*)newValue {SETTER_METHOD_FSN(newValue, artistSort )}
- (void) setAlbumArtistSort           :(NSString*)newValue {SETTER_METHOD_FSN(newValue, albumArtistSort )}
- (void) setAlbumSort                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, albumSort )}
- (void) setTitleSort                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, titleSort )}
- (void) setComposerSort              :(NSString*)newValue {SETTER_METHOD_FSN(newValue, composerSort )}
- (void) setIsrc                      :(NSString*)newValue {SETTER_METHOD_FSN(newValue, isrc )}
- (void) setReleaseDate               :(NSString*)newValue {SETTER_METHOD_FSN(newValue, releaseDate )}
- (void) setUrl                       :(NSString*)newValue {SETTER_METHOD_FSN(newValue, url )}
- (void) setTotalTracks               :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, totalTracks )}
- (void) setTotalDiscs                :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, totalDiscs )}



@end

