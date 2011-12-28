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
		String const ALBUM_ARTIST = "aART";
		String const COMPOSER     = "\251wrt";
		String const GROUPING     = "\251grp";
		
		String const COMPILATION  = "cpil";
		String const BPM          = "tmpo";
		
		String const TRACK_NUMBER = "trkn";
		String const TOTAL_TRACKS = "trkn";
		String const DISK_NUMBER  = "disk";
		String const TOTAL_DISKS  = "disk";
		
		String const ENCODER      = "\251too";
		String const COVER        = "covr";
		String const URL          = "----:com.apple.iTunes:URL_OFFICIAL_RELEASE_SITE";
		
		const String ARTIST_SORT  = "soar";
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
		
		extern const char* ARTIST_SORT;

	}	
}


#endif
