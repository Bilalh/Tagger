//
//  NSString+Regex.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 04/08/2012.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

@interface NSString (Regex)

- (BOOL) hasVaildData;

- (NSString *)stringByDecodingXMLEntities;

+ (NSString*) stringWithContentsOfURLCleaned:(NSURL *)url
                                       error:(NSError**)err;

+ (NSData *)cleanUTF8:(NSData *)data;

@end
