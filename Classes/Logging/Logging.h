//
//  Logging.h].h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "DDLog.h"

#ifdef DEBUG
#define LOG_LEVEL(log_level) static const int ddLogLevel = log_level;
#else
#define LOG_LEVEL(log_level) static const int ddLogLevel = LOG_LEVEL_ERROR;
#endif