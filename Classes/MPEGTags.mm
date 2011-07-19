//
//  MP3Tags.mm
//  VGTagger
//
//  Created by Bilal Syed Hussain on 19/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MPEGTags.h"
#import "TagStructs.h"

#include <iostream>
#include <string>


using namespace TagLib;
@implementation MPEGTags

- (id) initWithFilename:(NSString *)filename
{
    self = [super initWithFilename:filename];
    if (self) {
		data->f->mpeg = new MPEG::File([filename UTF8String]);
		data->file = data->f->mpeg;
		[self initFields];
    }
    
    return self;	
}

- (void)dealloc
{
    [super dealloc];
}


@end
