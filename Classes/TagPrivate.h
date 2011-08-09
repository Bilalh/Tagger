//
//  TagPrivate.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011  All rights reserved.
//

#ifndef TAGPRIVATE_HEADER
#define TAGPRIVATE_HEADER

#define TAG_SETTER_START(key)                              \
if ([key isEqualTo:newValue]) return;                      \
DDLogInfo(@"Setting %s from %@ to %@",#key, key, newValue);\
key = newValue;

#endif