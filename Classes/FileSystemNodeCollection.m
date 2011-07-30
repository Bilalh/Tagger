//
//  FileSystemCollection.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 30/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "FileSystemNodeCollection.h"
#import "FileSystemNode.h"

@implementation FileSystemNodeCollection
@synthesize tagsArray;
@dynamic hasBasicMetadata, hasExtenedMetadata;
@dynamic title, artist, album, comment, genre, year, track, length;
@dynamic albumArtist, composer, grouping, bpm, totalTracks, disc, totalDiscs, complication, url, cover;

-(void) setTagsArray:(NSArray *)newArray
{
	tagsArray = newArray;
	if (!tagsArray || [tagsArray count] ==0){
		hasExtenedMetadata = hasExtenedMetadata = NO;
		return;
	}
	
	hasExtenedMetadata = hasBasicMetadata = YES;
	
	for (FileSystemNode *n in tagsArray) {
		if (n.isDirectory){
			hasExtenedMetadata = hasExtenedMetadata = NO;
			return;
		}
		hasBasicMetadata   &= n.hasBasicMetadata;
		hasExtenedMetadata &= n.hasExtenedMetadata;
	}
}

@end
