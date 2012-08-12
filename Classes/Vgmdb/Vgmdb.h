//
//  Vgmdb.h
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>

struct _Vgmdb;

@interface Vgmdb : NSObject

    struct _Vgmdb;


/// Returns array of results for the string
//{
//    album = {
//        "@english" = "Atelier Rorona ~The Alchemist of Arland~ Arland of Music";
//    },
//    catalog = "N/A",
//    released = "Sep 28, 2010",
//    url = "http://vgmdb.net/album/21270"
//}
- (id) searchResults:(NSString*)search;

// Returns a Dictionary with data of the album
- (NSDictionary*)getAlbumData:(NSURL*) url;

- (NSDictionary*)getAlbumData:(NSURL*) url
                     encoding:(NSStringEncoding)encoding;

// Gets a sorted array from the above Dictionary
- (NSArray*)getTracksArray:(NSDictionary*)data;

@end