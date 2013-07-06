//
//  Fields.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 22/07/2011.
//  Copyright 2011-2013  All rights reserved.
//

#ifndef FIELDS_HEADERR
#define FIELDS_HEADERR

#include <tstring.h> 

// Contains the identifier for the fields of each mediatype
namespace Fields {
	
	namespace MP4 {
		using TagLib::String;
		String const ARTIST                        = "\251ART";
		String const ALBUM                         = "\251alb";
		String const TITLE                         = "\251nam";
		String const TRACK_NUMBER                  = "trkn";
		String const YEAR                          = "\251day";
		String const GENRE                         = "\251gen";
		String const COMMENT                       = "\251cmt";
		String const ALBUM_ARTIST                  = "aART";
		String const COMPOSER                      = "\251wrt";
		String const GROUPING                      = "\251grp";
		String const DISC_NUMBER                   = "disk";
		String const COVER                         = "covr";
		String const BPM                           = "tmpo";
		String const MUSICBRAINZ_ARTISTID          = "----:com.apple.iTunes:MusicBrainz Artist Id";
		String const MUSICBRAINZ_RELEASEID         = "----:com.apple.iTunes:MusicBrainz Album Id";
		String const MUSICBRAINZ_RELEASE_ARTISTID  = "----:com.apple.iTunes:MusicBrainz Album Artist Id";
		String const MUSICBRAINZ_TRACK_ID          = "----:com.apple.iTunes:MusicBrainz Track Id";
		String const MUSICBRAINZ_DISC_ID           = "----:com.apple.iTunes:MusicBrainz Disc Id";
		String const MUSICIP_ID                    = "----:com.apple.iTunes:MusicIP PUID";
		String const AMAZON_ID                     = "----:com.apple.iTunes:ASIN";
		String const MUSICBRAINZ_RELEASE_STATUS    = "----:com.apple.iTunes:MusicBrainz Album Status";
		String const MUSICBRAINZ_RELEASE_TYPE      = "----:com.apple.iTunes:MusicBrainz Album Type";
		String const MUSICBRAINZ_RELEASE_COUNTRY   = "----:com.apple.iTunes:MusicBrainz Album Release Country";
		String const LYRICS                        = "\251lyr";
		String const COMPILATION                   = "cpil";
		String const ARTIST_SORT                   = "soar";
		String const ALBUM_ARTIST_SORT             = "soaa";
		String const ALBUM_SORT                    = "soal";
		String const TITLE_SORT                    = "sonm";
		String const COMPOSER_SORT                 = "soco";
		String const ENCODER                       = "\251too";
		String const ISRC                          = "----:com.apple.iTunes:ISRC";
		String const BARCODE                       = "----:com.apple.iTunes:BARCODE";
		String const CATALOG_NO                    = "----:com.apple.iTunes:CATALOGNUMBER";
		String const RECORD_LABEL                  = "----:com.apple.iTunes:LABEL";
		String const LYRICIST                      = "----:com.apple.iTunes:LYRICIST";
		String const CONDUCTOR                     = "----:com.apple.iTunes:CONDUCTOR";
		String const REMIXER                       = "----:com.apple.iTunes:REMIXER";
		String const MOOD                          = "----:com.apple.iTunes:MOOD";
		String const MEDIA                         = "----:com.apple.iTunes:MEDIA";
		String const URL                           = "----:com.apple.iTunes:URL_OFFICIAL_RELEASE_SITE";
		String const DISCOGS_RELEASE_SITE_URL      = "----:com.apple.iTunes:URL_DISCOGS_RELEASE_SITE";
		String const WIKIPEDIA_RELEASE_SITE_URL    = "----:com.apple.iTunes:URL_WIKIPEDIA_RELEASE_SITE";
		String const OFFICIAL_ARTIST_SITE_URL      = "----:com.apple.iTunes:URL_OFFICIAL_ARTIST_SITE";
		String const DISCOGS_ARTIST_SITE_URL       = "----:com.apple.iTunes:URL_DISCOGS_ARTIST_SITE";
		String const WIKIPEDIA_ARTIST_SITE_URL     = "----:com.apple.iTunes:URL_WIKIPEDIA_ARTIST_SITE";
		String const LANGUAGE                      = "----:com.apple.iTunes:LANGUAGE";
		String const LYRICS_SITE_URL               = "----:com.apple.iTunes:URL_LYRICS_SITE";
		String const TOTAL_TRACKS                  = "trkn";
		String const TOTAL_DISCS                   = "disk";

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
	}	
}


#endif
