//
//  GroupingsPreferencesViewController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 29/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "ArrayDefaultsPreferencesViewController.h"

@implementation ArrayDefaultsPreferencesViewController
@synthesize table, title;

#pragma mark - init

- (id)initWithKey:(NSString *)aKey
{
	key = aKey;
	self.title  = [[key capitalizedString] stringByAppendingString:@":"];
	return [super initWithNibName:@"ArrayDefaultsPreferencesView" bundle:nil];
}

#pragma mark - Table


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
	return [[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key] count];
}


- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	return [[[NSUserDefaults standardUserDefaults] 
			 mutableArrayValueForKey:key] 
			objectAtIndex:rowIndex];
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(NSInteger)rowIndex
{
	[[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key] 
	 replaceObjectAtIndex:rowIndex withObject:anObject];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) removeRow:sender
{
	NSUInteger selected = [table selectedRow];
	if (selected == -1) return;
	
	[[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key] 
	 removeObjectAtIndex:selected];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[table noteNumberOfRowsChanged];
	
	// Set the select row
	if ([table numberOfRows] > 0){
		if (selected >= [table numberOfRows]){
			selected--;
		}
		[table selectRowIndexes:[NSIndexSet indexSetWithIndex:selected] byExtendingSelection:NO];
		[table scrollRowToVisible:selected];	
	}
}

- (IBAction) addRow:sender
{
	[[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key] 
	 addObject:[NSString stringWithFormat:@"New %@", key]];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[table noteNumberOfRowsChanged];
	
	// Start editing the selected row.
	NSUInteger count = [table numberOfRows] -1;
	[table selectRowIndexes:[NSIndexSet indexSetWithIndex:count] byExtendingSelection:NO];
	[table scrollRowToVisible:count];
	[table editColumn:0 row:count withEvent:nil select:YES];
}


#pragma mark - MASPreferencesViewController

- (NSString *)toolbarItemIdentifier
{
    return key;
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString([key capitalizedString], 
							 @"Toolbar item name for the Groupings preference pane");
}

@end
