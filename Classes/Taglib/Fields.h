//
//  Fields.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 22/07/2011.
//  Copyright 2011-2013  All rights reserved.
//

#ifndef FIELDS_HEADERR
#define FIELDS_HEADERR

#import <Foundation/Foundation.h>

// Contains the identifier for the fields of each mediatype
namespace Fields {
	
	namespace MP4 {
        extern NSString* const ARTIST;
		extern NSString* const ALBUM;
		extern NSString* const TITLE;
		extern NSString* const TRACK_NUMBER;
		extern NSString* const YEAR;
		extern NSString* const GENRE;
		extern NSString* const COMMENT;
		extern NSString* const ALBUM_ARTIST;
		extern NSString* const COMPOSER;
		extern NSString* const GROUPING;
		extern NSString* const DISC_NUMBER;
		extern NSString* const COVER;
		extern NSString* const BPM;
		extern NSString* const MUSICBRAINZ_ARTISTID;
		extern NSString* const MUSICBRAINZ_RELEASEID;
		extern NSString* const MUSICBRAINZ_RELEASE_ARTISTID;
		extern NSString* const MUSICBRAINZ_TRACK_ID;
		extern NSString* const MUSICBRAINZ_DISC_ID;
		extern NSString* const MUSICIP_ID;
		extern NSString* const AMAZON_ID;
		extern NSString* const MUSICBRAINZ_RELEASE_STATUS;
		extern NSString* const MUSICBRAINZ_RELEASE_TYPE;
		extern NSString* const MUSICBRAINZ_RELEASE_COUNTRY;
		extern NSString* const LYRICS;
		extern NSString* const COMPILATION;
		extern NSString* const ARTIST_SORT;
		extern NSString* const ALBUM_ARTIST_SORT;
		extern NSString* const ALBUM_SORT;
		extern NSString* const TITLE_SORT;
		extern NSString* const COMPOSER_SORT;
		extern NSString* const ENCODER;
		extern NSString* const ISRC;
		extern NSString* const BARCODE;
		extern NSString* const CATALOG_NO;
		extern NSString* const RECORD_LABEL;
		extern NSString* const LYRICIST;
		extern NSString* const CONDUCTOR;
		extern NSString* const REMIXER;
		extern NSString* const MOOD;
		extern NSString* const MEDIA;
		extern NSString* const URL;
		extern NSString* const DISCOGS_RELEASE_SITE_URL;
		extern NSString* const WIKIPEDIA_RELEASE_SITE_URL;
		extern NSString* const OFFICIAL_ARTIST_SITE_URL;
		extern NSString* const DISCOGS_ARTIST_SITE_URL;
		extern NSString* const WIKIPEDIA_ARTIST_SITE_URL;
		extern NSString* const LANGUAGE;
		extern NSString* const LYRICS_SITE_URL;
		extern NSString* const TOTAL_TRACKS;
		extern NSString* const TOTAL_DISCS;
        extern NSString* const RELEASE_DATE;
	}
	
	namespace MPEG {
		extern const char* ARTIST;
		extern const char* ALBUM;
		extern const char* TITLE;
		extern const char* TRACK_NUMBER;
		extern const char* YEAR;
		extern const char* GENRE;
		extern const char* COMMENT;
		extern const char* ALBUM_ARTIST;
		extern const char* COMPOSER;
		extern const char* GROUPING;
		extern const char* DISC_NUMBER;
		extern const char* COVER;
		extern const char* BPM;
		extern const char* MUSICBRAINZ_ARTISTID;
		extern const char* MUSICBRAINZ_RELEASEID;
		extern const char* MUSICBRAINZ_RELEASE_ARTISTID;
		extern const char* MUSICBRAINZ_TRACK_ID;
		extern const char* MUSICBRAINZ_DISC_ID;
		extern const char* MUSICIP_ID;
		extern const char* AMAZON_ID;
		extern const char* MUSICBRAINZ_RELEASE_STATUS;
		extern const char* MUSICBRAINZ_RELEASE_TYPE;
		extern const char* MUSICBRAINZ_RELEASE_COUNTRY;
		extern const char* LYRICS;
		extern const char* COMPILATION;
		extern const char* ARTIST_SORT;
		extern const char* ALBUM_ARTIST_SORT;
		extern const char* ALBUM_SORT;
		extern const char* TITLE_SORT;
		extern const char* COMPOSER_SORT;
		extern const char* ENCODER;
		extern const char* ISRC;
		extern const char* BARCODE;
		extern const char* CATALOG_NO;
		extern const char* RECORD_LABEL;
		extern const char* LYRICIST;
		extern const char* CONDUCTOR;
		extern const char* REMIXER;
		extern const char* MOOD;
		extern const char* MEDIA;
		extern const char* URL;
		extern const char* DISCOGS_RELEASE_SITE_URL;
		extern const char* WIKIPEDIA_RELEASE_SITE_URL;
		extern const char* OFFICIAL_ARTIST_SITE_URL;
		extern const char* DISCOGS_ARTIST_SITE_URL;
		extern const char* WIKIPEDIA_ARTIST_SITE_URL;
		extern const char* LANGUAGE;
		extern const char* LYRICS_SITE_URL;
		extern const char* TOTAL_TRACKS;
		extern const char* TOTAL_DISCS;
        
        extern const char* RELEASE_DATE;
	}
}


#endif
