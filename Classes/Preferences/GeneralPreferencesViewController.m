//
//  Created by Vadim Shpakovski on 4/22/11.
//  Copyright 2011 Shpakovski. All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "MainController.h"
#import "ImageAndTextCell.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);


@implementation GeneralPreferencesViewController
@synthesize tableColumns;

#pragma mark - init

- (id)initWithMainController:(MainController*)aMainController
{
	self = [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
    if (self) {
		mainController = aMainController;
		tableColumns = [[NSMutableDictionary alloc] init];
		for (NSTableColumn *c in [mainController.table tableColumns]) {
			[tableColumns setValue:c forKey: [c identifier]];
		}
		DDLogVerbose(@"cols %@", tableColumns);
    }
    return self;
}

-(void)awakeFromNib
{
	NSURL *url = 	[[NSUserDefaults standardUserDefaults] URLForKey:@"startUrl"];
	NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
	[img setSize:NSMakeSize(16, 16)];
	[imageCell setImage:img];
}


#pragma mark - Gui callback

- (IBAction) open:(id)sender
{
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanChooseDirectories:YES];
    if ([op runModal] != NSOKButton) return;    
	[self setStartUrl:[op URL]];
} 

- (IBAction) setStartUrlToCurrent:(id)sender
{
	[self setStartUrl: [[[mainController directoryStack] 
						 lastObject] URL]];
}

- (void) setStartUrl:(NSURL*)url
{
	[[NSUserDefaults standardUserDefaults] setURL:url forKey:@"startUrl"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
	[img setSize:NSMakeSize(16, 16)];
	[imageCell setImage:img];
}

#pragma mark - MASPreferencesViewController

- (NSString *)toolbarItemIdentifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

@end
