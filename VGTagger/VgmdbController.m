//
//  VgmdbController.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 08/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "VgmdbController.h"
#import <MacRuby/MacRuby.h>


@implementation VgmdbController

- (id)initWithWindow:(NSWindow *)awindow
{
    self = [super initWithWindow:awindow];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

//	id vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
//	NSDictionary *result = [vgmdb performRubySelector:@selector(search:)
//										withArguments:@"a", nil];
//	NSDictionary *result = [vgmdb performRubySelector:@selector(get_data:)
//										withArguments:@"/Users/bilalh/Programming/Cocoa/VGTagger/VGTagger/TestFiles/test2.html", nil];

//	NSLog(@"hash %@", result);

@end
