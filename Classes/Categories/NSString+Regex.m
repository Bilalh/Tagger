//
//  NSString+Regex.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 04/08/2012.
//  Copyright (c) 2012
//

#import "NSString+Regex.h"
#include <iconv.h>

@implementation NSString (Regex)

- (BOOL) hasVaildData
{
    return (self && [self length] != 0 && ![self isMatchedByRegex:@"^[,.()\\~ - \"'\\[\\]:!@]+$"]);
}

- (NSString *)stringByDecodingXMLEntities
{
    NSUInteger myLength = [self length];
    NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return self;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%u", charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

+ (NSString*) stringWithContentsOfURLCleaned:(NSURL *)url
                                       error:(NSError**)err
{
    NSString *text =  [NSString stringWithContentsOfURL: url
                                               encoding:NSISOLatin1StringEncoding
                                                  error:err];
    
    NSData *bytes= [text dataUsingEncoding:NSISOLatin1StringEncoding];
    NSData *cleanedData = [NSString cleanUTF8:bytes];
    NSString *cleaned = [[NSString alloc] initWithData:cleanedData encoding:NSUTF8StringEncoding];
    return cleaned;
}

+ (NSData *)cleanUTF8:(NSData *)data
{
    // Make sure its utf-8
    iconv_t ic= iconv_open("UTF-8", "UTF-8");
    // Remove invaild characters
    int one = 1;
    iconvctl(ic, ICONV_SET_DISCARD_ILSEQ, &one);
    
    size_t inBytes, outBytes;
    inBytes = outBytes = data.length;
    char *inbuf  = (char*)data.bytes;
    char *outbuf = (char*) malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    
    if (iconv(ic, &inbuf, &inBytes, &outptr, &outBytes) == (size_t) - 1) {
        assert(false);
        return nil;
    }
    
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outBytes];
    iconv_close(ic);
    free(outbuf);
    return result;
}


@end
