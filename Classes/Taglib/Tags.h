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
	
	NSBitmapImageRep *coverRep;
	NSString *kind;

	NSString *artist;
	NSString *album;
	NSString *title;
	NSNumber *track;
	NSNumber *year;
	NSString *genre;
	NSString *comment;
	NSString *albumArtist;
	NSString *composer;
	NSString *grouping;
	NSNumber *disc;
	NSImage *cover;
	NSNumber *bpm;
	NSString *musicbrainzArtistid;
	NSString *musicbrainzReleaseid;
	NSString *musicbrainzReleaseArtistid;
	NSString *musicbrainzTrackId;
	NSString *musicbrainzDiscId;
	NSString *musicipId;
	NSString *amazonId;
	NSString *musicbrainzReleaseStatus;
	NSString *musicbrainzReleaseType;
	NSString *musicbrainzReleaseCountry;
	NSString *lyrics;
	NSNumber *compilation;
	NSString *artistSort;
	NSString *albumArtistSort;
	NSString *albumSort;
	NSString *titleSort;
	NSString *composerSort;
	NSString *encoder;
	NSString *isrc;
	NSString *barcode;
	NSString *catalogNo;
	NSString *recordLabel;
	NSString *lyricist;
	NSString *conductor;
	NSString *remixer;
	NSString *mood;
	NSString *media;
	NSString *url;
	NSString *discogsReleaseSiteUrl;
	NSString *wikipediaReleaseSiteUrl;
	NSString *officialArtistSiteUrl;
	NSString *discogsArtistSiteUrl;
	NSString *wikipediaArtistSiteUrl;
	NSString *language;
	NSString *lyricsSiteUrl;
	NSNumber *totalTracks;
	NSNumber *totalDiscs;
	
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
