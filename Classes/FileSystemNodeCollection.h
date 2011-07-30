//
//  FileSystemCollection.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileSystemNodeCollection : NSObject {
@private
	NSArray *tagsArray;
	BOOL hasBasicMetadata;
	BOOL hasExtenedMetadata;
	
	NSString *albumArtist;
	NSString *composer;
	NSString *grouping;
	NSNumber *bpm;
	NSNumber *totalTracks;
	NSNumber *disc;
	NSNumber *totalDiscs;
	NSNumber *complication;
	
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
}

/// @name Finding nodes

/// Array of FileSystemNodes.
@property (assign) NSArray *tagsArray;

/// @name Finding General metadata.

/// YES if all the files has basic metadata info.
@property (readonly) BOOL  hasBasicMetadata;
/// YES if all the files has extend metadata info.
@property (readonly) BOOL  hasExtenedMetadata;

/// The title of the file
@property (assign) NSString *title; 
/// The album of the file
@property (assign) NSString *album; 
/// The artist of the file
@property (assign) NSString *artist; 
/// The comment of the file
@property (assign) NSString *comment;
/// The genre of the file
@property (assign) NSString *genre;
/// The year of the file
@property (assign) NSNumber *year;
/// The track# of the file
@property (assign) NSNumber *track; 
/// The length of the file in seconds
@property (assign,readonly) NSNumber *length; 

/// @name Finding Extra Metadata 

/// The album artist of the file
@property (assign) NSString *albumArtist;
/// The composer of the file
@property (assign) NSString *composer;
/// The grouping of the file
@property (assign) NSString *grouping;
/// The grouping of the file
@property (assign) NSNumber *bpm;
/// The total number of tracks in the album
@property (assign) NSNumber *totalTracks;
/// The disc# of the file
@property (assign) NSNumber *disc;
/// The total number of discs in the album
@property (assign) NSNumber *totalDiscs;
/// YES if the track is part of a complication.
@property (assign) NSNumber *complication;

// The url associated with the file
@property (assign) NSString *url;
// The album cover of the file
@property (assign) NSImage *cover;

@end
