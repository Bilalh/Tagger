//
//  fields.cpp
//  Tagger
//
//  Created by Bilal Syed Hussain on 28/12/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#include "fields.h"

namespace Fields {	
	namespace MPEG{
		const char* ARTIST                        = "TPE1";
		const char* ALBUM                         = "TALB";
		const char* TITLE                         = "TIT2";
		const char* TRACK_NUMBER                  = "TRCK";
		const char* YEAR                          = "TDRC";
		const char* GENRE                         = "TCON";
		const char* COMMENT                       = "COMM";
		const char* ALBUM_ARTIST                  = "TPE2";
		const char* COMPOSER                      = "TCOM";
		const char* GROUPING                      = "TIT1";
		const char* DISK_NUMBER                   = "TPOS";
		const char* COVER                         = "APIC";
		const char* BPM                           = "TBPM";
		const char* MUSICBRAINZ_ARTISTID          = "TXXX:MusicBrainz Artist Id";
		const char* MUSICBRAINZ_RELEASEID         = "TXXX:MusicBrainz Album Id";
		const char* MUSICBRAINZ_RELEASEARTISTID   = "TXXX:MusicBrainz Album Artist Id";
		const char* MUSICBRAINZ_TRACK_ID          = "UFID:http://musicbrainz.org";
		const char* MUSICBRAINZ_DISC_ID           = "TXXX:MusicBrainz Disc Id";
		const char* MUSICIP_ID                    = "TXXX:MusicIP PUID";
		const char* AMAZON_ID                     = "TXXX:ASIN";
		const char* MUSICBRAINZ_RELEASE_STATUS    = "TXXX:MusicBrainz Album Status";
		const char* MUSICBRAINZ_RELEASE_TYPE      = "TXXX:MusicBrainz Album Type";
		const char* MUSICBRAINZ_RELEASE_COUNTRY   = "TXXX:MusicBrainz Album Release Country";
		const char* LYRICS                        = "USLT:description";
		const char* COMPILATION                   = "TCMP";
		const char* ARTIST_SORT                   = "TSOP";
		const char* ALBUM_ARTIST_SORT             = "TSO2";
		const char* ALBUM_SORT                    = "TSOA";
		const char* TITLE_SORT                    = "TSOT";
		const char* COMPOSER_SORT                 = "TSOC";
		const char* ENCODER                       = "TENC";
		const char* ISRC                          = "TSRC";
		const char* BARCODE                       = "TXXX:BARCODE";
		const char* CATALOG_NO                    = "TXXX:CATALOGNUMBER";
		const char* RECORD_LABEL                  = "TPUB";
		const char* LYRICIST                      = "TEXT";
		const char* CONDUCTOR                     = "TPE3";
		const char* REMIXER                       = "TPE4";
		const char* MOOD                          = "TMOO";
		const char* MEDIA                         = "TMED";
		const char* URL                           = "WXXX:OFFICIAL_RELEASE";
		const char* DISCOGS_RELEASE_SITE_URL      = "WXXX:DISCOGS_RELEASE";
		const char* WIKIPEDIA_RELEASE_SITE_URL    = "WXXX:WIKIPEDIA_RELEASE";
		const char* OFFICIAL_ARTIST_SITE_URL      = "WOAR";
		const char* DISCOGS_ARTIST_SITE_URL       = "WXXX:DISCOGS_ARTIST";
		const char* WIKIPEDIA_ARTIST_SITE_URL     = "WXXX:WIKIPEDIA_ARTIST";
		const char* LANGUAGE                      = "TLAN";
		const char* KEY                           = "TKEY";
		const char* LYRICS_SITE_URL               = "WXXX:LYRICS_SITE";
		const char* TOTAL_TRACKS                  = "TRCK";
		const char* TOTAL_DISCS                   = "TPOS";
		
		
	}
}