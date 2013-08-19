//
//  TabLibOC.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 06/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>
struct FileData;

/// Tags allows reading and writing of tags of audio files
@interface Tags : NSObject {
	@protected
	struct FileData* data;  /// The tag data
	
	// Field that are handed by the subclasses
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
	NSBitmapImageRep *coverRep;
	
	NSString *kind;
	
	// Tracks may be handed by the subclass
	NSNumber *track;
	// MP3 comment need to be handled by the subclass
	NSString *comment;
	
	//	Sort by
	
	NSString *albumSort;
	NSString *artistSort;
	NSString *titleSort;
	NSString *composerSort;
	NSString *albumArtistSort;
    

    // Misc
    NSString *isrc;
    NSString *releaseDate;
    
}

/// @name Initializing an Tags Object


 /**  
  * Creates and finds the tags of the specifed file
  * should be used on one of the subclass e.g MP4Tag
  *
  * @param filename The filepath to the file.
  *
  * @return A new Tags.
  */
-(id) initWithFilename:(NSString *)filename;


 /**  
  *  Gives value to the fields class should call this method in subclasses initWithFilename.
  */
-(void) initFields;


/** Compares the tag to another tag.
 
 Order album, disc, then track
 
 @param otherTag an tag instance.
 @return a NSComparisonResult 
 */
-(NSComparisonResult)compare:(Tags *)otherTag;


/** Returns a filename for the array of format strings
 
 @param formatStrings If any of the strings is a name of a field it will be replaced by the value of that field (except cover)
 @return The filename
 */
-(NSString*)filenameFromFormatArray:(NSArray*)formatStrings;

- (NSString*) displayName;

- (void) removeAllTags;

/// @name Finding General metadata.

/// The title of the file
@property (strong,nonatomic) NSString *title; 
/// The album of the file
@property (strong,nonatomic) NSString *album; 
/// The artist of the file
@property (strong,nonatomic) NSString *artist; 
/// The comment of the file
@property (strong,nonatomic) NSString *comment;
/// The genre of the file
@property (strong,nonatomic) NSString *genre;
/// The year of the file
@property (nonatomic)  NSNumber *year;
/// The track# of the file
@property (nonatomic) NSNumber *track; 
/// The length of the file in seconds
@property (readonly) NSNumber *length; 
/// The bitrate of the file in kb/s
@property (readonly) NSNumber *bitrate; 
/// The sample rate of the file
@property (readonly) NSNumber *sampleRate;
/// The bitrate of the file in kb/s
@property (readonly) NSNumber *channels;
/// The kind of the file
@property (strong,nonatomic) NSString *kind;

/// @name Finding Extra Metadata 

/// The album artist of the file
@property (strong,nonatomic) NSString *albumArtist;
/// The composer of the file
@property (strong,nonatomic) NSString *composer;
/// The grouping of the file
@property (strong,nonatomic) NSString *grouping;
/// The grouping of the file
@property (strong,nonatomic) NSNumber *bpm;
/// The total number of tracks in the album
@property (strong,nonatomic) NSNumber *totalTracks;
/// The disc# of the file
@property  (nonatomic) NSNumber *disc;
/// The total number of discs in the album
@property (nonatomic) NSNumber *totalDiscs;
/// YES if the track is part of a compilation.
@property (nonatomic) NSNumber *compilation;

// The url associated with the file
@property (strong,nonatomic) NSString *url;
// The album cover of the file
@property (strong,nonatomic) NSImage *cover;

/// @name Finding Sort by  Metadata 

@property (strong,nonatomic) NSString *albumSort;
@property (strong,nonatomic) NSString *artistSort;
@property (strong,nonatomic) NSString *titleSort;
@property (strong,nonatomic) NSString *composerSort;
@property (strong,nonatomic) NSString *albumArtistSort;


/// @name Misc

/// The Isrc of the file
@property (strong,nonatomic) NSString *isrc;

/// The Release Date of the album
@property (strong,nonatomic) NSString *releaseDate;


@end
