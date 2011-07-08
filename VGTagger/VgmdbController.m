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
@synthesize query, vgmdb;

- (IBAction) search:(id)sender{
	NSLog(@"Search button pressed");
	NSDictionary *result = [vgmdb performRubySelector:@selector(search:)
										withArguments:@"Atelier Meruru", 
							nil];

	NSLog(@"Serch Results %@", result);
}

- (id)initWithWindow:(NSWindow *)awindow
{
    self = [super initWithWindow:awindow];
    if (self) {
		vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
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



@end
