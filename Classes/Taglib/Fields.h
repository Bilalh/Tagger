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
/// Contains fields for directory accessing fields 
namespace MP4Fields {
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
}

#endif
