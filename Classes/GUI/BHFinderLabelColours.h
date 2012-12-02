//
//  BHFinderLabelColours.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 12/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BHFinderLabelColours : NSObject {
@private
    
}

+ (NSGradient *)gradientForLabelIndex:(NSInteger)colourIndex;

enum BHLabelColors
{
	BHLabelColorNone   = 0,
	BHLabelColorRed    = 6,
	BHLabelColorOrange = 7,
	BHLabelColorYellow = 5,
	BHLabelColorGreen  = 2,
	BHLabelColorBlue   = 4,
	BHLabelColorPurple = 3,
	BHLabelColorGray   = 1
};

@end
