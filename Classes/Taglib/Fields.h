//
//  Fields.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 22/07/2011.
//  Copyright 2011  All rights reserved.
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
		String const DISK_NUMBER                   = "disk";
		String const COVER                         = "covr";
		String const BPM                           = "tmpo";
		String const MUSICBRAINZ_ARTISTID          = "----:com.apple.iTunes:MusicBrainz Artist Id";
		String const MUSICBRAINZ_RELEASEID         = "----:com.apple.iTunes:MusicBrainz Album Id";
		String const MUSICBRAINZ_RELEASEARTISTID   = "----:com.apple.iTunes:MusicBrainz Album Artist Id";
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
		String const KEY                           = "----:com.apple.iTunes:KEY";
		String const LYRICS_SITE_URL               = "----:com.apple.iTunes:URL_LYRICS_SITE";
		String const TOTAL_TRACKS                  = "trkn";
		String const TOTAL_DISCS                   = "disk";

		
	}
	
	namespace MPEG {
		extern const char *ALBUM_ARTIST;
		extern const char *COMPOSER    ;
		extern const char *GROUPING    ;
		
		extern const char *COMPILATION ;
		extern const char *BPM         ;
		
		extern const char *TRACK_NUMBER;
		extern const char *TOTAL_TRACKS;
		extern const char *DISK_NUMBER ;
		extern const char *TOTAL_DISKS ;
		
		extern const char *ENCODER     ;
		extern const char *COVER       ;
		extern const char *COMMENT     ;
		extern const char *URL         ;
		
		extern const char* ALBUM_SORT;
		extern const char* ARTIST_SORT;
		extern const char* TITLE_SORT;
		extern const char* COMPOSER_SORT;
		extern const char* ALBUM_ARTIST_SORT;
		
		extern const char* LYRICS;
		
	}	
}


#endif
