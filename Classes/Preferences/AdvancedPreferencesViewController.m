//
//  AdvancedPreferencesViewController.m
//  Tagger
//
//  Created by Bilal Syed Hussain on 10/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "AdvancedPreferencesViewController.h"

@implementation AdvancedPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"AdvancedPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)toolbarItemIdentifier
{
    return @"AdvancedPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Advanced", @"Toolbar item name for the Advanced preference pane");
}

@end
