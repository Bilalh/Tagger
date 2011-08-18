//
//  Logging.h].h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "DDLog.h"


#define LOG_FLAG_RELEASE  (1 << 4)  // 0...010000


#define LOG_LEVEL_RELEASE   (LOG_FLAG_RELEASE | LOG_FLAG_ERROR) // 0...010001



#define DDLogRelease(frmt, ...)    SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_LEVEL_RELEASE,0,  frmt, ##__VA_ARGS__)
#define DDLogCRelease(frmt, ...)   SYNC_LOG_C_MAYBE(ddLogLevel, LOG_LEVEL_RELEASE,0,  frmt, ##__VA_ARGS__)



#ifdef DEBUG
#define LOG_LEVEL(log_level) static const int ddLogLevel = log_level;
#else
#define LOG_LEVEL(log_level) static const int ddLogLevel = LOG_LEVEL_ERROR;
#endif