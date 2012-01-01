//
//  FileSystemCollection.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "FileSystemNodeCollection.h"
#import "FileSystemNode.h"
#import "Tags.h"
#import "NSImage+bitmapData.h"

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
@dynamic urls;
@synthesize tagsArray, hasBasicMetadata, hasExtenedMetadata, containsMP4Files, empty, labelColor, labelIndex, length;

@synthesize artist, album, title, track, year;
@synthesize genre, comment, albumArtist, composer, grouping;
@synthesize disc, cover, bpm, musicbrainzArtistid, musicbrainzReleaseid;
@synthesize musicbrainzReleaseArtistid, musicbrainzTrackId, musicbrainzDiscId, musicipId, amazonId;
@synthesize musicbrainzReleaseStatus, musicbrainzReleaseType, musicbrainzReleaseCountry, lyrics, compilation;
@synthesize artistSort, albumArtistSort, albumSort, titleSort, composerSort;
@synthesize encoder, isrc, barcode, catalogNo, recordLabel;
@synthesize lyricist, conductor, remixer, mood, media;
@synthesize url, discogsReleaseSiteUrl, wikipediaReleaseSiteUrl, officialArtistSiteUrl, discogsArtistSiteUrl;
@synthesize wikipediaArtistSiteUrl, language, lyricsSiteUrl, totalTracks, totalDiscs;



#pragma mark -
#pragma mark Init

+ (void)initialize
{
	tagFieldNames =  [[NSArray alloc] initWithObjects:
					  @"artist", @"album", @"title", @"track", @"year",
					  @"genre", @"comment", @"albumArtist", @"composer", @"grouping",
					  @"disc", @"cover", @"bpm", @"musicbrainzArtistid", @"musicbrainzReleaseid",
					  @"musicbrainzReleaseArtistid", @"musicbrainzTrackId", @"musicbrainzDiscId", @"musicipId", @"amazonId",
					  @"musicbrainzReleaseStatus", @"musicbrainzReleaseType", @"musicbrainzReleaseCountry", @"lyrics", @"compilation",
					  @"artistSort", @"albumArtistSort", @"albumSort", @"titleSort", @"composerSort",
					  @"encoder", @"isrc", @"barcode", @"catalogNo", @"recordLabel",
					  @"lyricist", @"conductor", @"remixer", @"mood", @"media",
					  @"url", @"discogsReleaseSiteUrl", @"wikipediaReleaseSiteUrl", @"officialArtistSiteUrl", @"discogsArtistSiteUrl",
					  @"wikipediaArtistSiteUrl", @"language", @"lyricsSiteUrl", @"totalTracks", @"totalDiscs", nil];
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
	hasBasicMetadata = hasExtenedMetadata = NO; 
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

/// set the new array and finds the metdata for each tag
- (void)setTagsArray:(NSArray *)newArray
{
	DDLogVerbose(@"newArray %@", newArray);
	tagsArray = newArray;
	if (!tagsArray || [tagsArray count] ==0){
		[self nilAllFields];
		self.empty = YES;
		return;
	}
	
	self.empty = NO;
	hasExtenedMetadata = hasBasicMetadata = YES;
	
	for (FileSystemNode *n in tagsArray) {
		if (n.isDirectory){
			[self nilAllFields];
			[self initColor];
			return;
		}
		hasBasicMetadata   &= n.hasBasicMetadata;
		hasExtenedMetadata &= n.hasExtenedMetadata;
	}
	
	DDLogVerbose(@"basic:%d extened %d", hasBasicMetadata, hasExtenedMetadata);
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

- (void) setArtist                    :(NSString*)newValue {SETTER_METHOD_FSN(newValue, artist)}
- (void) setAlbum                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, album)}
- (void) setTitle                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, title)}
- (void) setTrack                     :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, track)}
- (void) setYear                      :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, year)}
- (void) setGenre                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, genre)}
- (void) setComment                   :(NSString*)newValue {SETTER_METHOD_FSN(newValue, comment)}
- (void) setAlbumArtist               :(NSString*)newValue {SETTER_METHOD_FSN(newValue, albumArtist)}
- (void) setComposer                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, composer)}
- (void) setGrouping                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, grouping)}
- (void) setDisc                      :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, disc)}
- (void) setCover                     :(NSImage*)newValue  {SETTER_METHOD_FSN(newValue, cover)}
- (void) setBpm                       :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, bpm)}
- (void) setMusicbrainzArtistid       :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzArtistid)}
- (void) setMusicbrainzReleaseid      :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzReleaseid)}
- (void) setMusicbrainzReleaseArtistid:(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzReleaseArtistid)}
- (void) setMusicbrainzTrackId        :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzTrackId)}
- (void) setMusicbrainzDiscId         :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzDiscId)}
- (void) setMusicipId                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicipId)}
- (void) setAmazonId                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, amazonId)}
- (void) setMusicbrainzReleaseStatus  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzReleaseStatus)}
- (void) setMusicbrainzReleaseType    :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzReleaseType)}
- (void) setMusicbrainzReleaseCountry :(NSString*)newValue {SETTER_METHOD_FSN(newValue, musicbrainzReleaseCountry)}
- (void) setLyrics                    :(NSString*)newValue {SETTER_METHOD_FSN(newValue, lyrics)}
- (void) setCompilation               :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, compilation)}
- (void) setArtistSort                :(NSString*)newValue {SETTER_METHOD_FSN(newValue, artistSort)}
- (void) setAlbumArtistSort           :(NSString*)newValue {SETTER_METHOD_FSN(newValue, albumArtistSort)}
- (void) setAlbumSort                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, albumSort)}
- (void) setTitleSort                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, titleSort)}
- (void) setComposerSort              :(NSString*)newValue {SETTER_METHOD_FSN(newValue, composerSort)}
- (void) setEncoder                   :(NSString*)newValue {SETTER_METHOD_FSN(newValue, encoder)}
- (void) setIsrc                      :(NSString*)newValue {SETTER_METHOD_FSN(newValue, isrc)}
- (void) setBarcode                   :(NSString*)newValue {SETTER_METHOD_FSN(newValue, barcode)}
- (void) setCatalogNo                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, catalogNo)}
- (void) setRecordLabel               :(NSString*)newValue {SETTER_METHOD_FSN(newValue, recordLabel)}
- (void) setLyricist                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, lyricist)}
- (void) setConductor                 :(NSString*)newValue {SETTER_METHOD_FSN(newValue, conductor)}
- (void) setRemixer                   :(NSString*)newValue {SETTER_METHOD_FSN(newValue, remixer)}
- (void) setMood                      :(NSString*)newValue {SETTER_METHOD_FSN(newValue, mood)}
- (void) setMedia                     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, media)}
- (void) setUrl                       :(NSString*)newValue {SETTER_METHOD_FSN(newValue, url)}
- (void) setDiscogsReleaseSiteUrl     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, discogsReleaseSiteUrl)}
- (void) setWikipediaReleaseSiteUrl   :(NSString*)newValue {SETTER_METHOD_FSN(newValue, wikipediaReleaseSiteUrl)}
- (void) setOfficialArtistSiteUrl     :(NSString*)newValue {SETTER_METHOD_FSN(newValue, officialArtistSiteUrl)}
- (void) setDiscogsArtistSiteUrl      :(NSString*)newValue {SETTER_METHOD_FSN(newValue, discogsArtistSiteUrl)}
- (void) setWikipediaArtistSiteUrl    :(NSString*)newValue {SETTER_METHOD_FSN(newValue, wikipediaArtistSiteUrl)}
- (void) setLanguage                  :(NSString*)newValue {SETTER_METHOD_FSN(newValue, language)}
- (void) setLyricsSiteUrl             :(NSString*)newValue {SETTER_METHOD_FSN(newValue, lyricsSiteUrl)}
- (void) setTotalTracks               :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, totalTracks)}
- (void) setTotalDiscs                :(NSNumber*)newValue {SETTER_METHOD_FSN(newValue, totalDiscs)}

@end

