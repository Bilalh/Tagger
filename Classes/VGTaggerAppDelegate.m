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
@synthesize window, mainController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Vgmdb" ofType:@"rb"];
	[[MacRuby sharedRuntime] evaluateFileAtPath:path];
	[[DDTTYLogger sharedInstance ] setLogFormatter:	[[[PSDDFormatter alloc ] init ] autorelease]];
	[DDLog addLogger:[DDASLLogger sharedInstance]];
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	// Set the fallback values for preferences
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"]]];
	
	// Get the users preferences
	NSUserDefaults *preferences = [[NSUserDefaults standardUserDefaults] retain];
	
	NSInteger i = [preferences integerForKey:@"interval"];
	NSLog(@"i:%ld",i);
	NSLog(@"test %@", [preferences stringForKey:@"test"]);
	[preferences setValue:@"testingNot" forKey:@"test"];
	
	// Save
	[preferences synchronize];
}

// Handle a file dropped on the dock icon
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path
{
	NSString *dirPath = ([[path pathExtension ] isEqualToString:@""]) 
	? path 
	: [path stringByDeletingLastPathComponent];
	
	[self.mainController goToDirectory:[[NSURL alloc] initFileURLWithPath:dirPath]];
	
	return YES;
}


@end
