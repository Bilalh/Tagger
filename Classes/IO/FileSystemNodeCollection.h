//
//  FileSystemCollection.h
//  Tagger
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
@property  (nonatomic) NSArray *tagsArray;


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
@property  (nonatomic)   NSNumber *labelIndex;


/// The title of the file
@property  (nonatomic) NSString *title; 
/// The album of the file
@property  (nonatomic) NSString *album; 
/// The artist of the file
@property  (nonatomic) NSString *artist; 
/// The comment of the file
@property  (nonatomic) NSString *comment;
/// The genre of the file
@property  (nonatomic) NSString *genre;
/// The year of the file
@property  (nonatomic) NSNumber *year;
/// The track# of the file
@property  (nonatomic) NSNumber *track; 
/// The length of the file in seconds
@property (readonly) NSNumber *length; 

/// @name Finding Extra Metadata 

/// The album artist of the file
@property  (nonatomic) NSString *albumArtist;
/// The composer of the file
@property  (nonatomic) NSString *composer;
/// The grouping of the file
@property  (nonatomic) NSString *grouping;
/// The grouping of the file
@property  (nonatomic) NSNumber *bpm;
/// The total number of tracks in the album
@property  (nonatomic) NSNumber *totalTracks;
/// The disc# of the file
@property  (nonatomic) NSNumber *disc;
/// The total number of discs in the album
@property  (nonatomic) NSNumber *totalDiscs;
/// YES if the track is part of a compilation.
@property  (nonatomic) NSNumber *compilation;

// The url associated with the file
@property  (nonatomic) NSString *url;
// The album cover of the file
@property  (nonatomic) NSImage *cover;

/// @name Finding Sort by  Metadata 

@property  (nonatomic) NSString *albumSort;
@property  (nonatomic) NSString *artistSort;
@property  (nonatomic) NSString *titleSort;
@property  (nonatomic) NSString *composerSort;
@property  (nonatomic) NSString *albumArtistSort;

@end
