//
//  TabLibOC.h
//  VGTagger
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
	// MP3 comment need to be handled the subclass
	NSString *comment;
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


/// @name Finding General metadata.

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
@property (readonly) NSNumber *length; 
/// The bitrate of the file in kb/s
@property (readonly) NSNumber *bitrate; 
/// The sample rate of the file
@property (readonly) NSNumber *sampleRate;
/// The bitrate of the file in kb/s
@property (readonly) NSNumber *channels;
/// The kind of the file
@property (assign) NSString *kind;

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
/// YES if the track is part of a compilation.
@property (assign) NSNumber *compilation;

// The url associated with the file
@property (assign) NSString *url;
// The album cover of the file
@property (assign) NSImage *cover;

@end
