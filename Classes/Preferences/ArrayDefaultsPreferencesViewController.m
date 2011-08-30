//
//  GroupingsPreferencesViewController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 29/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "ArrayDefaultsPreferencesViewController.h"
#import "NSMutableArray+Stack.h"
#define ARRAY_TABLE_VIEW_ROW_TYPE @"aRow"

@implementation ArrayDefaultsPreferencesViewController
@synthesize table, title;


#pragma mark - init

- (id)initWithKey:(NSString *)aKey
{
	key = aKey;
	self.title  = [[key capitalizedString] stringByAppendingString:@":"];
	return [super initWithNibName:@"ArrayDefaultsPreferencesView" bundle:nil];
}

- (void) awakeFromNib
{
	[table registerForDraggedTypes:[[table registeredDraggedTypes ] arrayByAddingObject:ARRAY_TABLE_VIEW_ROW_TYPE]];
}

#pragma mark - Table data source


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


#pragma mark - Table delgate
// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
	 toPasteboard:(NSPasteboard*)pboard
{
    // Copy the row numbers to the pasteboard.
    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:ARRAY_TABLE_VIEW_ROW_TYPE] owner:self];
    [pboard setData:zNSIndexSetData forType:ARRAY_TABLE_VIEW_ROW_TYPE];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv 
				validateDrop:(id <NSDraggingInfo>)info 
				 proposedRow:(NSInteger)row 
	   proposedDropOperation:(NSTableViewDropOperation)op
{
    return NSDragOperationEvery;
}


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row 
	dropOperation:(NSTableViewDropOperation)operation
{
	
	NSPasteboard* pboard   = [info draggingPasteboard];
    NSData* rowData        = [pboard dataForType:ARRAY_TABLE_VIEW_ROW_TYPE];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow      = [rowIndexes firstIndex];
	
	
    // Move the specified row to its new location...
	// if we remove a row then everything moves down by one
	// so do an insert prior to the delete
	if (dragRow < row) {
		[[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key] 
		 swapObjectAtIndex:row from:dragRow removeFirst:NO];
		[self.table noteNumberOfRowsChanged];
		[self.table reloadData];
		
		return YES;
		
	}
	
	[[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key] 
	 swapObjectAtIndex:row from:dragRow removeFirst:YES];
	[self.table noteNumberOfRowsChanged];
	[self.table reloadData];
	
	return YES;
}


#pragma mark - Table +/- row

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
