//
//  NSAttributedString+Hyperlink.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 27/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"


@implementation NSAttributedString (NSAttributedString_Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
	NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
	NSRange range = NSMakeRange(0, [attrString length]);
 	
	[attrString beginEditing];
	[attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
 	
	// make the text appear in blue
	[attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
 	
	// next make the text appear with an underline
	[attrString addAttribute:
 	 NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
 	
	[attrString endEditing];
 	
	return [attrString autorelease];
}

@end
