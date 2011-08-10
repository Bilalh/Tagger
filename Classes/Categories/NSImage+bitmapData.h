//
//  bitmapData.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 29/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSImage (NSImage_bitmapData)

- (NSData*) bitmapDataForType:(NSBitmapImageFileType)type;

@end