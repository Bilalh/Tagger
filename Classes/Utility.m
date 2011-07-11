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

// Recursively looks into the result until the result is 
// a string or number, selectedLanguage is the Language to 
// choose 
+ (id) valueFromResult:(id)result
			 selectedLanguage:(NSString*)selectedLanguage
{
	if ([result isKindOfClass:[NSDictionary class]]){
		return [Utility valueFromResult:[result objectForKey:selectedLanguage] 
					   selectedLanguage:selectedLanguage];
		
	}else if ([result isKindOfClass:[NSArray class]]){
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		for (id ele in result) {
			[array addObject:[Utility valueFromResult:ele
									 selectedLanguage:selectedLanguage ]];
		}
		return [array componentsJoinedByString:@","];
		
	}
	
	return result;
}


@end
