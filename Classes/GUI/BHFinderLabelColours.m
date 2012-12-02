//
//  BHFinderLabelColours.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 12/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "BHFinderLabelColours.h"


@implementation BHFinderLabelColours

+ (NSGradient *)gradientForLabelIndex:(NSInteger)colourIndex
{
	NSGradient *gradient = nil;
	
	switch (colourIndex) {
		case BHLabelColorNone:
			;
			break;
			
		case BHLabelColorRed:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.976471 green:0.639216 blue:0.623529 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.964706 green:0.368627 blue:0.360784 alpha:1.0]];
			break;
		case BHLabelColorOrange:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.972549 green:0.811765 blue:0.584314 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.952941 green:0.662745 blue:0.286275 alpha:1.0]];
			break;
		case BHLabelColorYellow:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.972549 green:0.956863 blue:0.619608 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.925490 green:0.862745 blue:0.305882 alpha:1.0]];
			break;
		case BHLabelColorGreen:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.835294 green:0.925490 blue:0.619608 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.698039 green:0.850980 blue:0.301961 alpha:1.0]];
			break;
		case BHLabelColorBlue:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.678431 green:0.819608 blue:0.996078 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.368627 green:0.627451 blue:0.988235 alpha:1.0]];
			break;
		case BHLabelColorPurple:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.862745 green:0.749020 blue:0.917647 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.749020 green:0.537255 blue:0.839216 alpha:1.0]];
			break;
		case BHLabelColorGray:
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.811765 green:0.811765 blue:0.811765 alpha:1.0] endingColor:[NSColor colorWithCalibratedRed:0.658824 green:0.658824 blue:0.658824 alpha:1.0]];
			break;
			
		default:
			break;
	}
	
	return gradient;
}

@end
