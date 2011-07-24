//
//  VGTaggerAppDelegate.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "VGTaggerAppDelegate.h"
#import "MainController.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "PSDDFormatter.h"

#import <MacRuby/MacRuby.h>


@implementation VGTaggerAppDelegate
@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Vgmdb" ofType:@"rb"];
	[[MacRuby sharedRuntime] evaluateFileAtPath:path];
	[[DDTTYLogger sharedInstance ] setLogFormatter:	[[[PSDDFormatter alloc ] init ] autorelease]];
	[DDLog addLogger:[DDASLLogger sharedInstance]];
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
