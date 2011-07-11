//
//  Utility.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "Utility.h"


@implementation Utility

#pragma mark -
#pragma mark Hash Methods

+ (id) valueFromResult:(id)result
			 selectedLanguage:(NSString*)selectedLanguage
{
	if ([result isKindOfClass:[NSDictionary class]]){
		return [result objectForKey:selectedLanguage];
	}
	return result;
}


@end
