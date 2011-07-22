//
//  Fields.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 22/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#ifndef FIELDS_HEADERR
#define FIELDS_HEADERR

#include <tstring.h> 

/// Contains fields for directory accessing fields 
namespace MP4Fields {
	TagLib::String const ALBUM_ARTIST = "aART";
	TagLib::String const COMPOSER = "\251wrt";
	TagLib::String const GROUPING = "\251grp";
	
	TagLib::String const COMPILATION = "cpil";
	TagLib::String const BPM = "tmpo";
	
	TagLib::String const TRACK_NUMBER = "trkn";
	TagLib::String const TOTAL_TRACKS = "trkn";
	TagLib::String const DISK_NUMBER  = "disk";
	TagLib::String const TOTAL_DISKS  = "disk";
	
	TagLib::String const ENCODER = "\251too";
	TagLib::String const COVER = "covr";
	
	//extern TagLib::String const MP4_ARTIST;
	//extern TagLib::String const MP4_ALBUM;
	//extern TagLib::String const MP4_YEAR;
	//extern TagLib::String const MP4_GENRE;
	//extern TagLib::String const MP4_TITLE;
	//extern TagLib::String const MP4_COMMENT;
	
}

#endif