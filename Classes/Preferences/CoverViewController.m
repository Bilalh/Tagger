
//
//  CoverViewController.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 10/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "CoverViewController.h"


#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);

static const NSSet *tokensSet;

@implementation CoverViewController
@synthesize tokenField;

#pragma mark - Init

- (id)init
{
    return [super initWithNibName:@"CoverView" bundle:nil];
}


+ (void) initialize
{
	tokensSet = [[NSSet alloc ] initWithObjects:
				 @"title",  @"album",  @"artist", @"composer", @"year",
				 @"track",  @"disc",   @"genre",  @"albumArtist",
				 nil];
}

#pragma mark -
#pragma mark Token Field Delegate

// capitalized tokens
- (NSString *)          tokenField:(NSTokenField *)tokenField 
 displayStringForRepresentedObject:(id)representedObject
{
	return [representedObject capitalizedString];
}

// Only highlight predefined tokens
- (NSTokenStyle)tokenField:(NSTokenField *)tokenField
 styleForRepresentedObject:(id)representedObject
{
	if ([tokensSet containsObject:representedObject]) {
		return NSRoundedTokenStyle;	
	}else{
		return NSPlainTextTokenStyle;	
	}
}

// Keeps the whitespace.
- (id)                  tokenField:(NSTokenField *)tokenField 
 representedObjectForEditingString:(NSString *)editingString
{
	return editingString;
}

// Do not let token be editable after they have been made.
- (NSString *)          tokenField:(NSTokenField *)tokenField 
 editingStringForRepresentedObject:(id)representedObject
{
	return nil;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	if ([[fieldEditor string] isEqualToString:@""]){
		return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)toolbarItemIdentifier
{
    return @"Cover";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Cover", @"Toolbar item name for the Cover preference pane");
}


@end
