//
//  VGTaggerAppDelegate.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "VGTaggerAppDelegate.h"
#import <MacRuby/MacRuby.h>

@implementation VGTaggerAppDelegate
@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Vgmdb" ofType:@"rb"];
//	[[MacRuby sharedRuntime] evaluateFileAtPath:path];

}

@end
