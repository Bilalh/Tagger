//
//  FileSystemCollection.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tags;

/// This provides a wrapper around a array of filesystem nodes
/// It allows the tags to every node in the collection at the same time
/// to allow muti-row editing.
@interface FileSystemNodeCollection : NSObject {
@private
	NSArray *tagsArray;
	BOOL hasBasicMetadata;
	BOOL hasExtenedMetadata;
	
	BOOL containsMP4Files;
	NSString *albumArtist;
	NSString *composer;
	NSString *grouping;
	NSNumber *bpm; 
	NSNumber *totalTracks;
	NSNumber *disc;
	NSNumber *totalDiscs;
	NSNumber *compilation;
	
	NSString *url;
	NSImage *cover;
	
	NSString *title; 
	NSString *album; 
	NSString *artist;
	NSString *comment;
	NSString *genre;
	NSNumber *year;
	NSNumber *track; 
	NSNumber *length;
	
	NSColor  *labelColor;
	NSNumber *labelIndex;
	BOOL writeToAll;
	BOOL  empty;
	
	// Tags  -- sort by	
	NSString *albumSort;
	NSString *artistSort;
	NSString *titleSort;
	NSString *composerSort;
	NSString *albumArtistSort;
	
}

/// @name General

/// Array of FileSystemNodes.
@property (assign) NSArray *tagsArray;


/** Renames each selected node with the specifed format 
 
 @param formatStrings An Array of strings 
 @return NSError with the error data.
 */
- (NSError*)renameWithFormatArray:(NSArray*)formatStrings;
- (NSError*)tagsWithFormatArrayFromFilename:(NSArray*)formatStrings;


- (void) performBlockOnTags:(const NSArray*)tagsNames
					  block:(id (^)(id value, NSString *tagName, Tags *tags ))block;

- (void) performBlockOnTag:(NSString*)tagsName
					 block:(id (^)(id value, NSString *tagName, Tags *tags ))block;

- (void)deleteAllTags;


- (void)swapFirstAndLastName:(NSString*)key;

/// @name Finding General metadata.

// YES if empty
@property (assign) BOOL  empty;

/// YES if all the files has basic metadata info.
@property (readonly) BOOL  hasBasicMetadata;
/// YES if all the files has extend metadata info.
@property (readonly) BOOL  hasExtenedMetadata;

@property (readonly) BOOL  containsMP4Files;

@property (readonly) NSArray *urls;

@property (readonly) NSColor  *labelColor;
@property (assign)   NSNumber *labelIndex;

/// The length of the file in seconds
@property (assign,readonly) NSNumber *length; 


/// The Artist of the file
@property (assign) NSString *artist;
/// The Album of the file
@property (assign) NSString *album;
/// The Title of the file
@property (assign) NSString *title;
/// The Track Number of the file
@property (assign) NSNumber *track;
/// The Year of the file
@property (assign) NSNumber *year;
/// The Genre of the file
@property (assign) NSString *genre;
/// The Comment of the file
@property (assign) NSString *comment;
/// The Album Artist of the file
@property (assign) NSString *albumArtist;
/// The Composer of the file
@property (assign) NSString *composer;
/// The Grouping of the file
@property (assign) NSString *grouping;
/// The Disc Number of the file
@property (assign) NSNumber *disc;
/// The Cover of the file
@property (assign) NSImage *cover;
/// The Bpm of the file
@property (assign) NSNumber *bpm;
/// The Musicbrainz Artistid of the file
@property (assign) NSString *musicbrainzArtistid;
/// The Musicbrainz Releaseid of the file
@property (assign) NSString *musicbrainzReleaseid;
/// The Musicbrainz Release artistid of the file
@property (assign) NSString *musicbrainzReleaseArtistid;
/// The Musicbrainz Track Id of the file
@property (assign) NSString *musicbrainzTrackId;
/// The Musicbrainz Disc Id of the file
@property (assign) NSString *musicbrainzDiscId;
/// The Musicip Id of the file
@property (assign) NSString *musicipId;
/// The Amazon Id of the file
@property (assign) NSString *amazonId;
/// The Musicbrainz Release Status of the file
@property (assign) NSString *musicbrainzReleaseStatus;
/// The Musicbrainz Release Type of the file
@property (assign) NSString *musicbrainzReleaseType;
/// The Musicbrainz Release Country of the file
@property (assign) NSString *musicbrainzReleaseCountry;
/// The Lyrics of the file
@property (assign) NSString *lyrics;
/// The Compilation of the file
@property (assign) NSNumber *compilation;
/// The Artist Sort of the file
@property (assign) NSString *artistSort;
/// The Album Artist Sort of the file
@property (assign) NSString *albumArtistSort;
/// The Album Sort of the file
@property (assign) NSString *albumSort;
/// The Title Sort of the file
@property (assign) NSString *titleSort;
/// The Composer Sort of the file
@property (assign) NSString *composerSort;
/// The Encoder of the file
@property (assign) NSString *encoder;
/// The Isrc of the file
@property (assign) NSString *isrc;
/// The Barcode of the file
@property (assign) NSString *barcode;
/// The Catalog No of the file
@property (assign) NSString *catalogNo;
/// The Record Label of the file
@property (assign) NSString *recordLabel;
/// The Lyricist of the file
@property (assign) NSString *lyricist;
/// The Conductor of the file
@property (assign) NSString *conductor;
/// The Remixer of the file
@property (assign) NSString *remixer;
/// The Mood of the file
@property (assign) NSString *mood;
/// The Media of the file
@property (assign) NSString *media;
/// The URL of the file
@property (assign) NSString *url;
/// The Discogs Release Site Url of the file
@property (assign) NSString *discogsReleaseSiteUrl;
/// The Wikipedia Release Site Url of the file
@property (assign) NSString *wikipediaReleaseSiteUrl;
/// The Official Artist Site Url of the file
@property (assign) NSString *officialArtistSiteUrl;
/// The Discogs Artist Site Url of the file
@property (assign) NSString *discogsArtistSiteUrl;
/// The Wikipedia Artist Site Url of the file
@property (assign) NSString *wikipediaArtistSiteUrl;
/// The Language of the file
@property (assign) NSString *language;
/// The Lyrics Site Url of the file
@property (assign) NSString *lyricsSiteUrl;
/// The Total Tracks of the file
@property (assign) NSNumber *totalTracks;
/// The Total Discs of the file
@property (assign) NSNumber *totalDiscs;


@end
