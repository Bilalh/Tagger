//
//  fields.cpp
//  Tagger
//
//  Created by Bilal Syed Hussain on 28/12/2011.
//  Copyright 2011-2013  All rights reserved.
//

#include "fields.h"

namespace Fields {
    
    namespace MP4{
        NSString* const ARTIST                        = @"©ART";
		NSString* const ALBUM                         = @"©alb";
		NSString* const TITLE                         = @"©nam";
		NSString* const TRACK_NUMBER                  = @"trkn";
		NSString* const YEAR                          = @"©day";
		NSString* const GENRE                         = @"©gen";
		NSString* const COMMENT                       = @"©cmt";
		NSString* const ALBUM_ARTIST                  = @"aART";
		NSString* const COMPOSER                      = @"©wrt";
		NSString* const GROUPING                      = @"©grp";
		NSString* const DISC_NUMBER                   = @"disk";
		NSString* const COVER                         = @"covr";
		NSString* const BPM                           = @"tmpo";
		NSString* const MUSICBRAINZ_ARTISTID          = @"com.apple.iTunes:MusicBrainz Artist Id";
		NSString* const MUSICBRAINZ_RELEASEID         = @"com.apple.iTunes:MusicBrainz Album Id";
		NSString* const MUSICBRAINZ_RELEASE_ARTISTID  = @"com.apple.iTunes:MusicBrainz Album Artist Id";
		NSString* const MUSICBRAINZ_TRACK_ID          = @"com.apple.iTunes:MusicBrainz Track Id";
		NSString* const MUSICBRAINZ_DISC_ID           = @"com.apple.iTunes:MusicBrainz Disc Id";
		NSString* const MUSICIP_ID                    = @"com.apple.iTunes:MusicIP PUID";
		NSString* const AMAZON_ID                     = @"com.apple.iTunes:ASIN";
		NSString* const MUSICBRAINZ_RELEASE_STATUS    = @"com.apple.iTunes:MusicBrainz Album Status";
		NSString* const MUSICBRAINZ_RELEASE_TYPE      = @"com.apple.iTunes:MusicBrainz Album Type";
		NSString* const MUSICBRAINZ_RELEASE_COUNTRY   = @"com.apple.iTunes:MusicBrainz Album Release Country";
		NSString* const LYRICS                        = @"©lyr";
		NSString* const COMPILATION                   = @"cpil";
		NSString* const ARTIST_SORT                   = @"soar";
		NSString* const ALBUM_ARTIST_SORT             = @"soaa";
		NSString* const ALBUM_SORT                    = @"soal";
		NSString* const TITLE_SORT                    = @"sonm";
		NSString* const COMPOSER_SORT                 = @"soco";
		NSString* const ENCODER                       = @"©too";
		NSString* const ISRC                          = @"com.apple.iTunes.ISRC";
		NSString* const BARCODE                       = @"com.apple.iTunes:BARCODE";
		NSString* const CATALOG_NO                    = @"com.apple.iTunes:CATALOGNUMBER";
		NSString* const RECORD_LABEL                  = @"com.apple.iTunes:LABEL";
		NSString* const LYRICIST                      = @"com.apple.iTunes:LYRICIST";
		NSString* const CONDUCTOR                     = @"com.apple.iTunes:CONDUCTOR";
		NSString* const REMIXER                       = @"com.apple.iTunes:REMIXER";
		NSString* const MOOD                          = @"com.apple.iTunes:MOOD";
		NSString* const MEDIA                         = @"com.apple.iTunes:MEDIA";
		NSString* const URL                           = @"com.apple.iTunes:URL_OFFICIAL_RELEASE_SITE";
		NSString* const DISCOGS_RELEASE_SITE_URL      = @"com.apple.iTunes:URL_DISCOGS_RELEASE_SITE";
		NSString* const WIKIPEDIA_RELEASE_SITE_URL    = @"com.apple.iTunes:URL_WIKIPEDIA_RELEASE_SITE";
		NSString* const OFFICIAL_ARTIST_SITE_URL      = @"com.apple.iTunes:URL_OFFICIAL_ARTIST_SITE";
		NSString* const DISCOGS_ARTIST_SITE_URL       = @"com.apple.iTunes:URL_DISCOGS_ARTIST_SITE";
		NSString* const WIKIPEDIA_ARTIST_SITE_URL     = @"com.apple.iTunes:URL_WIKIPEDIA_ARTIST_SITE";
		NSString* const LANGUAGE                      = @"com.apple.iTunes:LANGUAGE";
		NSString* const LYRICS_SITE_URL               = @"com.apple.iTunes:URL_LYRICS_SITE";
		NSString* const TOTAL_TRACKS                  = @"trkn";
		NSString* const TOTAL_DISCS                   = @"disk";
        NSString* const RELEASE_DATE                  = @"©day";
    }

    
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
		const char* DISC_NUMBER                   = "TPOS";
		const char* COVER                         = "APIC";
		const char* BPM                           = "TBPM";
		const char* MUSICBRAINZ_ARTISTID          = "TXXX:MusicBrainz Artist Id";
		const char* MUSICBRAINZ_RELEASEID         = "TXXX:MusicBrainz Album Id";
		const char* MUSICBRAINZ_RELEASE_ARTISTID  = "TXXX:MusicBrainz Album Artist Id";
		const char* MUSICBRAINZ_TRACK_ID          = "UFID:http://musicbrainz.org";
		const char* MUSICBRAINZ_DISC_ID           = "TXXX:MusicBrainz Disc Id";
		const char* MUSICIP_ID                    = "TXXX:MusicIP PUID";
		const char* AMAZON_ID                     = "TXXX:ASIN";
		const char* MUSICBRAINZ_RELEASE_STATUS    = "TXXX:MusicBrainz Album Status";
		const char* MUSICBRAINZ_RELEASE_TYPE      = "TXXX:MusicBrainz Album Type";
		const char* MUSICBRAINZ_RELEASE_COUNTRY   = "TXXX:MusicBrainz Album Release Country";
		const char* LYRICS                        = "USLT";
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
		const char* URL                           = "WXXX";
		const char* DISCOGS_RELEASE_SITE_URL      = "WXXX:DISCOGS_RELEASE";
		const char* WIKIPEDIA_RELEASE_SITE_URL    = "WXXX:WIKIPEDIA_RELEASE";
		const char* OFFICIAL_ARTIST_SITE_URL      = "WOAR";
		const char* DISCOGS_ARTIST_SITE_URL       = "WXXX:DISCOGS_ARTIST";
		const char* WIKIPEDIA_ARTIST_SITE_URL     = "WXXX:WIKIPEDIA_ARTIST";
		const char* LANGUAGE                      = "TLAN";
		const char* LYRICS_SITE_URL               = "WXXX:LYRICS_SITE";
		const char* TOTAL_TRACKS                  = "TRCK";
		const char* TOTAL_DISCS                   = "TPOS";
        
        const char* RELEASE_DATE                   = "TDRL";

        
	}
}