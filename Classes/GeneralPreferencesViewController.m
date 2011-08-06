//
//  Created by Vadim Shpakovski on 4/22/11.
//  Copyright 2011 Shpakovski. All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "MainController.h"

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

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
		DDLogInfo(@"cols %@", tableColumns);
    }
    return self;
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
