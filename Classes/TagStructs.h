//
//  TagStructs.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 14/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#include <taglib.h>

#include <mp4file.h>
#include <mpegfile.h>


union FileDetails{
	TagLib::MP4::File  *mp4;
	TagLib::MPEG::File *mpeg;
};

struct FileData{
	TagLib::File *file;
	FileDetails *f;
};
