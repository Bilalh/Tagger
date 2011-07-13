//
//  Utility.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject {
@private
    
}

+ (id) valueFromResult:(id)result
	  selectedLanguage:(NSString*)selectedLanguage;

+(NSDictionary*) languagesDictionary;
+ (NSString*) stringFromLanguages:(NSDictionary*)title
			 selectedLanguage:(NSString*)selectedLanguage;

@end
