//
//  TaggerAppDelegate.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "VGTaggerAppDelegate.h"
#import "MainController.h"

#import "GeneralPreferencesViewController.h"
#import "AdvancedPreferencesViewController.h"
#import "CoverViewController.h"
#import "ArrayDefaultsPreferencesViewController.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "PSDDFormatter.h"
#import "MASPreferencesWindowController.h"


@implementation VGTaggerAppDelegate
@synthesize window, mainController, preferencesWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    
	[[DDTTYLogger sharedInstance ] setLogFormatter:	[[PSDDFormatter alloc ] init ]];
	[DDLog addLogger:[DDASLLogger sharedInstance]];
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
}


// Handle a file dropped on the dock icon
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path
{
	NSString *dirPath = ([[path pathExtension ] isEqualToString:@""]) 
	? path 
	: [path stringByDeletingLastPathComponent];
	
	[self.mainController showWindow:self];
	[self.mainController goToDirectory:[[NSURL alloc] initFileURLWithPath:dirPath]];
	
	return YES;
}

#pragma mark - Preferences

- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
		NSViewController *gp, *cv, *ap, *gr, *ge;
		gp = [[GeneralPreferencesViewController alloc] initWithMainController:mainController];
		cv = [[CoverViewController alloc] init];
		ap = [[AdvancedPreferencesViewController alloc] init];
		gr = [[ArrayDefaultsPreferencesViewController alloc] initWithKey:@"groupings"];
		ge = [[ArrayDefaultsPreferencesViewController alloc] initWithKey:@"genres"];
		
        NSArray *controllers = [[NSArray alloc] initWithObjects:
								gp, cv, gr,ge, ap,
								nil];
		
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}

- (IBAction)openPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

#pragma mark - Quicklook
- (IBAction)togglePreviewPanel:(id)previewPanel
{
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}

@end
