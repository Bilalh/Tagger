//
//  QuickLookTableView.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "QuickLookTableView.h"
#import "VGTaggerAppDelegate.h"

@implementation QuickLookTableView

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* key = [theEvent charactersIgnoringModifiers];
    if([key isEqual:@" "]) {
        [[NSApp delegate] togglePreviewPanel:self];
    } else {
        [super keyDown:theEvent];
    }
}

@end
