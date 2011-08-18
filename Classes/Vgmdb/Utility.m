//
//  Utility.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/07/2011.
//  Copyright 2011  All rights reserved.
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
				 [NSArray arrayWithObjects:@"@romaji",  @"@kanji",   @"@latin", nil], @"@english",
				 [NSArray arrayWithObjects:@"@kanji" ,  @"@english", @"@latin", nil], @"@romaji",
				 [NSArray arrayWithObjects:@"@romaji",  @"@english", @"@latin", nil], @"@kanji",
				 [NSArray arrayWithObjects:@"@english", @"@romaji",  @"@kanji", nil], @"@latin",
				 nil];
}


+(NSDictionary*) languagesDictionary
{
	return languages;
}

+ (NSString*) stringFromLanguages:(NSDictionary*)field
			 selectedLanguage:(NSString**)selectedLanguagePtr
{
	NSString* selectedLanguage =*selectedLanguagePtr;
	if ([field count] == 0) return nil;
		
	NSString *result = [field objectForKey:selectedLanguage];
	if (result) return result;
	
	// Checks each other Language
	for (NSString *newLanguage in [languages objectForKey:selectedLanguage] ) {
		result = [field objectForKey:newLanguage];
		if (result) {
			*selectedLanguagePtr = newLanguage;
			return result;	
		}
	}
	
	// if we can find it just return the first language
	return [[field allValues ] objectAtIndex:0];
}


+ (id) valueFromResult:(id)result
	  selectedLanguage:(NSString*)selectedLanguage
{
	return [self valueFromResult:result selectedLanguagePtr: &selectedLanguage];
}

// Recursively looks into the result until the result is 
// a string or number, selectedLanguage is the Language to 
// choose 
+ (id) valueFromResult:(id)result
	  selectedLanguagePtr:(NSString**)selectedLanguage
{
	if ([result isKindOfClass:[NSDictionary class]]){
		return [Utility valueFromResult:[Utility  stringFromLanguages:result selectedLanguage:selectedLanguage] 
					   selectedLanguagePtr:selectedLanguage];
		
	}else if ([result isKindOfClass:[NSArray class]]){
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		for (id ele in result) {
			id a = [Utility valueFromResult:ele
						   selectedLanguagePtr:selectedLanguage ];
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
