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
		const char *ALBUM_ARTIST = "TPE2";
		const char *COMPOSER     = "TCOM";
		const char *GROUPING     = "TIT1";
		
		const char *COMPILATION  = "TCMP";
		const char *BPM          = "TBPM";
		
		const char *TRACK_NUMBER = "TRCK";
		const char *TOTAL_TRACKS = "TRCK";
		const char *DISK_NUMBER  = "TPOS";
		const char *TOTAL_DISKS  = "TPOS";
		
		const char *ENCODER      = "TENC";
		const char *COVER        = "APIC";
		const char *URL          = "WXXX";
		const char *COMMENT      = "COMM";
		
		const char* ARTIST_SORT  = "TSOP";
	}
}