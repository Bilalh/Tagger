//
//  Utility.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 11/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>

/// Utility methods 
@interface Utility : NSObject {
@private
    
}

/** Converts a field to a string or NSNumber
 
 If there is multiple language only the selected is returned.
 If there is an array it is joined by commas expect 
 for two values which is joined by an &.
 
 @param result           The field to get the value from
 @param selectedLanguage A _pointer_ to the selected language, 
 which is updated with the new language.
 @return 
 */
+ (id) valueFromResult:(id)result
   selectedLanguagePtr:(NSString**)selectedLanguage;

+ (id) valueFromResult:(id)result
	  selectedLanguage:(NSString*)selectedLanguage;


/** Get the field in the selected language.
 
 @param field               The field to get the title from.
 @param selectedLanguagePtr A _pointer_ to the selected language, 
 which is updated with the new language.
 @return The title is the language in selectedLanguagePtr
 */
+ (NSString*) stringFromLanguages:(NSDictionary*)field
				 selectedLanguage:(NSString**)selectedLanguagePtr;

/** Returns a dictionary of language to try if the selected language 
 is not found 
 
 @return The dictinary of languages
 */
+(NSDictionary*) languagesDictionary;


@end
