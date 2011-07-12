//
//  Utility.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "Utility.h"


static NSDictionary *languages;

@implementation Utility

#pragma mark -
#pragma mark Hash Methods

+ (void) initialize
{
	[super initialize];
	languages = [[NSDictionary alloc] initWithObjectsAndKeys:
				 [NSArray arrayWithObjects:@"romaji",@"kanji",   nil], @"english",
				 [NSArray arrayWithObjects:@"kanji" ,@"english", nil], @"romaji",
				 [NSArray arrayWithObjects:@"romaji",@"english", nil], @"kanji",
				 nil];
}

+ (NSString*) stringFromTitle:(NSDictionary*)title
			 selectedLanguage:(NSString*)selectedLanguage
{
	if ([title count] == 0) return nil;
		
	NSString *result = [title objectForKey:selectedLanguage];
	if (result) return result;
	
	// Checks each other Language
	for (NSString *newLanguage in [languages objectForKey:selectedLanguage] ) {
		result = [title objectForKey:newLanguage];
		if (result) return result;
	}
	
	// if we can find it just return the first language
	return [[title allValues ] objectAtIndex:0];
}

// Recursively looks into the result until the result is 
// a string or number, selectedLanguage is the Language to 
// choose 
+ (id) valueFromResult:(id)result
			 selectedLanguage:(NSString*)selectedLanguage
{
	if ([result isKindOfClass:[NSDictionary class]]){
		return [Utility valueFromResult:[Utility  stringFromTitle:result selectedLanguage:selectedLanguage] 
					   selectedLanguage:selectedLanguage];
		
	}else if ([result isKindOfClass:[NSArray class]]){
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		for (id ele in result) {
			id a = [Utility valueFromResult:ele
						   selectedLanguage:selectedLanguage ];
			[array addObject:a];
		}
		switch ([array count]) {
			case 0: 
				return @"";
				break;
			case 1:
				return [array objectAtIndex:0];
			case 2:
				return [[array objectAtIndex:0] stringByAppendingString:[@" & " stringByAppendingString: [array objectAtIndex:1]]];
				break;
			default:
			{
				return [array componentsJoinedByString:@","];
				break;	
			}
		}
		
	}
	
	return result;
}


@end
