//
//  bitmapData.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 29/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSImage+bitmapData.h"


@implementation NSImage (NSImage_bitmapData)

- (NSData*) bitmapDataForType:(NSBitmapImageFileType)type
{
	NSCParameterAssert(nil != self);
	
	NSEnumerator		*enumerator					= nil;
	NSImageRep			*currentRepresentation		= nil;
	NSBitmapImageRep	*bitmapRep					= nil;
	NSSize				size;
	
	enumerator = [[self representations] objectEnumerator];
	while((currentRepresentation = [enumerator nextObject])) {
		if([currentRepresentation isKindOfClass:[NSBitmapImageRep class]]) {
			bitmapRep = (NSBitmapImageRep *)currentRepresentation;
		}
	}
	
	// Create a bitmap representation if one doesn't exist
	if(nil == bitmapRep) {
		size = [self size];
		[self lockFocus];
		bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:
					  NSMakeRect(0, 0, size.width, size.height)];
		[self unlockFocus];
	}
	
	return [bitmapRep representationUsingType:type properties:nil]; 	
}

@end
