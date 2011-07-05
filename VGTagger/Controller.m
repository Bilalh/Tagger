//
//  Controller.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "Controller.h"
#import <MacRuby/MacRuby.h>
#include <fileref.h>


@implementation Controller

@synthesize title;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
	
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (IBAction) search:(id)sender
{

	FileRef g("/Users/bilalh/Programming/Cocoa/VGTagger/VGTagger/TestFiles/aac.m4a");				

	
//	id vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
//	NSDictionary *result = [vgmdb performRubySelector:@selector(search:)
//										withArguments:@"a", nil];
//	NSDictionary *result = [vgmdb performRubySelector:@selector(get_data:)
//										withArguments:@"/Users/bilalh/Programming/Cocoa/VGTagger/VGTagger/TestFiles/test2.html", nil];
	
//	NSLog(@"hash %@", result);
}

@end


