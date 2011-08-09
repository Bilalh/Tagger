//
//  NSAttributedString+Hyperlink.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 27/07/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSAttributedString (NSAttributedString_Hyperlink)

 +(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end
