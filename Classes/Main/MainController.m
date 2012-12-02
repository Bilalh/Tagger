//
//  Controller.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "MainController.h"
#import "Tags.h"
#import "MP4Tags.h"
#import "VgmdbController.h"
#import "DisplayController.h"
#import "FileSystemNode.h"
#import "NSMutableArray+Stack.h"
#import "ImageAndTextCell.h"
#import "FileSystemNodeCollection.h"
#import "RenamingFilesController.h"
#import "DraggableImageView.h"
#import "IntPair.h"

#import "CCTColorLabelMenuItemView.h"


//#import <MacRuby/MacRuby.h>
#import "iTunes.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);

#define TABLE_VIEW_ROW_TYPE @"row"

static const NSArray *predefinedDirectories;
static const NSArray *predefinedRenameFormats;
static const NSArray *predefinedTagFormats;
static const NSArray *tagMenuValues;
static const NSArray *deleteMenuValues;
static const NSArray *swapMenuValues;


@interface MainController()  

- (void) initDirectoryTable;
- (void) setPopupMenuIcons;

- (void) backForwordDirectoriesCommon;

- (NSString *)stringFromFileSize:(NSInteger)size;

- (IBAction)renameWithPredefinedFormat:(id)sender;

- (void) openDirectoryNode: (FileSystemNode *) node;

/// Checks if there any music files
- (void) _vgmdbEnable;
- (void) _vgmdbEnableDir;


/// Change the current directory to the clicked entries
- (IBAction) onClick:(id)sender;

- (FileSystemNode*) nodeAtIndex:(NSInteger)row;
- (NSArray*) children;

-(NSString*)formatPair:(NSNumber*)first
				second:(NSNumber*)second;

- (void) copyTags:(NSWindow *)sheet 
	   returnCode:(int)returnCode 
	  contextInfo:(IntPair*)pair;

- (void) initTagManipulationSubMenus;
- (void) initGoMenuItems;


- (void) splitViewWillResizeSubviewsHandler:(id)object;

@end

@implementation FileSystemNode (QLPreviewItem)

- (NSURL *)previewItemURL
{
    return self.URL;
}

- (NSString *)previewItemTitle
{
    return self.displayName;
}

@end


@implementation MainController
@synthesize window, directoryStack, currentNodes,forwardStack, selectedNodeindex, parentNodes, table;
@synthesize vgmdbEnable=_vgmdbEnable, vgmdbEnableDir = _vgmdbEnableDir;
@dynamic forwordStackEnable, backwordStackEnable, labelMenu, openEnable;

#pragma mark - Table Methods 

- (IBAction)gotoNextRow:(id)sender
{
	if ([table numberOfRows] == 0) return;
	NSUInteger newRow, selected =  [table selectedRow];
	if (selected == -1){
		newRow = 0;	
	}else{
		newRow = (selected +1) % [table numberOfRows];
	}
	[table selectRowIndexes:[NSIndexSet indexSetWithIndex:newRow] byExtendingSelection:NO];
	[table scrollRowToVisible:newRow];
}

- (IBAction)gotoPreviousRow:(id)sender
{
	if ([table numberOfRows] == 0) return;
	NSUInteger newRow, selected =  [table selectedRow];
	if (selected == -1){
		newRow = 0;	
	}else{
		newRow = (selected + [table numberOfRows] - 1 ) % [table numberOfRows];
	}
	[table selectRowIndexes:[NSIndexSet indexSetWithIndex:newRow] byExtendingSelection:NO];
	[table scrollRowToVisible:newRow];
}

- (IBAction)openDirectory:(id)sender
{
	NSInteger row = [table selectedRow];
	if (row == -1) return;
	
	NSArray *children = [[directoryStack lastObject] children];
	FileSystemNode *node = [children objectAtIndex:row];
	if ([node isDirectory]){
		[self openDirectoryNode: node];
	}
}

- (void)openDirectoryNode: (FileSystemNode *) node
{
	[directoryStack addObject:node];
	[table reloadData];
	[parentNodes insertObject:node atIndex:0];
	[popup insertItemWithTitle:[node displayName] atIndex:0];
	[[popup itemAtIndex:0] setImage:[node icon]];
	self.selectedNodeindex = [NSNumber numberWithInteger:0];
	// clear the forward stack since it would not make sense any more
	[forwardStack removeAllObjects];
	[table deselectAll:self];
	[self _vgmdbEnable];
	[self _vgmdbEnableDir];
	[window setTitleWithRepresentedFilename:[[[directoryStack lastObject] URL ] path]];
}
- (IBAction)onClick:(id)sender
{
	NSInteger row = [table clickedRow];
	
	NSArray *children = [[directoryStack lastObject] children];
	FileSystemNode *node = [children objectAtIndex:row];
	DDLogVerbose(@"onClick selected %@", node);
	if ([node isDirectory]){
		[self openDirectoryNode: node];
	}else{
		// code to make cells that are editable go to edit
		NSEvent *currentEvent = [NSApp currentEvent];
		NSInteger column = [table clickedColumn];
		NSCell *theCell = [table preparedCellAtColumn:column row:row];
		NSRect cellFrame = [table frameOfCellAtColumn:column row:row];
		NSUInteger hitTestResult = [theCell hitTestForEvent:currentEvent inRect:cellFrame ofView:table];
		
		if ( ( hitTestResult & NSCellHitEditableTextArea ) != NSCellHitEditableTextArea ) return;
		if ([[[table tableColumns] objectAtIndex:column] isEditable]){
			[table editColumn:column row:row withEvent:currentEvent select:YES];	
		}
	}
}



- (NSString *)stringFromFileSize:(NSInteger)size
{
	double floatSize = size;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%zd bytes",size]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1lf KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1lf MB",floatSize]);
	floatSize = floatSize / 1024;	
	return([NSString stringWithFormat:@"%1.1lf GB",floatSize]);
}

-(NSString*)formatPair:(NSNumber*)first
				second:(NSNumber*)second
{
	if (first && second){
		return [NSString stringWithFormat:@"%@ of %@",first, second];
	}else if (first){
		return [NSString stringWithFormat:@"%@", first];
	}else if (second){
		return [NSString stringWithFormat:@"- of %@", second];
	}else{
		return @"-";
	}
}

- (NSInteger)labelColorForRow:(NSInteger)rowIndex
{
	return [([self nodeAtIndex:rowIndex]).labelIndex integerValue];
}

- (void) acceptFilenameDrag:(NSString *) path
{
	NSString *dirPath = ([[path pathExtension ] isEqualToString:@""]) 
	? path 
	: [path stringByDeletingLastPathComponent];

	[self goToDirectory:[[NSURL alloc] initFileURLWithPath:dirPath]];
}

#pragma mark - Table Menu (label)

- (NSMenu *)labelMenu
{
	if (!labelMenu)
	{
		NSMenu *menu = [[NSMenu alloc] init];
		NSMenuItem *item;
		
		item = [[NSMenuItem alloc] initWithTitle:@"Reveal in Finder" 
										   action:@selector(revealInFinder:) 
									keyEquivalent:@""];
		[menu addItem:item];
		[menu addItem:[NSMenuItem separatorItem]];
		
		// add our custom label picker view menu item
		CCTColorLabelMenuItemView *labelTrackView = [[CCTColorLabelMenuItemView alloc] initWithFrame:NSMakeRect(0, 0, 190, 50)];
		labelTrackView.delegate = self;
		item = [[NSMenuItem alloc] initWithTitle:@"Label" 
										   action:@selector(applyLabelToSelectedRows:) 
									keyEquivalent:@""];
		[item setTarget:self];
		[item setView:labelTrackView];
		[menu addItem:item];
		
		
		labelMenu = menu;
	}
	
	return labelMenu;
}

- (void)applyLabelToSelectedRows:(CCTColorLabelMenuItemView *)labelView
{	
	NSInteger clickedRow = [table clickedRow];
	NSIndexSet *iset = [table selectedRowIndexes];
	
	[iset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		([self nodeAtIndex:idx]).labelIndex = 
		[NSNumber numberWithInteger:labelView.selectedLabel];
		[table setNeedsDisplayInRect:[table rectOfRow:idx]];
	}];
	
	if (![iset containsIndex:clickedRow]){
		([self nodeAtIndex:clickedRow]).labelIndex = 
		[NSNumber numberWithInteger:labelView.selectedLabel];
		[table setNeedsDisplayInRect:[table rectOfRow:clickedRow]];
	}
}

#pragma mark - CCTColorLabelMenuView Delegate

- (NSInteger)currentlySelectedLabel:(CCTColorLabelMenuItemView *)colorLabelMenuItemView
{
	// first check to see if clickedRow is valid - the user may have right-clicked on a row that is not selected
	NSInteger rowForMenu = [table clickedRow];
	if (rowForMenu < 0) {
		rowForMenu = [table selectedRow];
	}
	
	if (rowForMenu < 0) {
		return -1;
	}

	return [[[self nodeAtIndex:rowForMenu] labelIndex] integerValue];
}


#pragma mark - Table Delegate


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
    return [[[directoryStack lastObject] children] count];
}


- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	NSArray *children = [[directoryStack lastObject] children];
	FileSystemNode *node = [children objectAtIndex:rowIndex];
	
	
	if ( [[aTableColumn identifier] isEqualToString:@"filename"] ){
		return [node displayName];
    }else if ([[aTableColumn identifier] isEqualToString:@"labelIndex"]){
        return [[node labelIndex] stringValue];
	}else if ([node isDirectory]){
		return @"";
	}else if ([[aTableColumn identifier] isEqualToString:@"size"]){
		return [self stringFromFileSize:[[node size] integerValue]];
	}else if ([[aTableColumn identifier] isEqualToString:@"trackPair"]){
		return [self formatPair:node.tags.track second:node.tags.totalTracks];
	}else if ([[aTableColumn identifier] isEqualToString:@"discPair"]){
		return [self formatPair:node.tags.disc second:node.tags.totalDiscs];		
    }
	
	return [node.tags valueForKey:[aTableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(NSInteger)rowIndex
{
	
	NSArray *children = [[directoryStack lastObject] children];
	FileSystemNode *node = [children objectAtIndex:rowIndex];
	
	if ([[aTableColumn identifier] isEqualToString:@"filename"]) return;
	[node.tags setValue:anObject forKey:[aTableColumn identifier]];
}


// Shows the icon for the file
- (void)tableView:(NSTableView *)tableView 
  willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn
			  row:(NSInteger)rowIndex
{
	if ([[tableColumn identifier] isEqualToString:@"filename"]){
		NSArray *children = [[directoryStack lastObject] children];
		FileSystemNode *node = [children objectAtIndex:rowIndex];
		NSImage *icon = [node icon];
		[icon setSize:NSMakeSize(16, 16)];
		[(ImageAndTextCell*)cell setImage: icon];
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	const NSInteger selectedRow = [table selectedRow];

	if (selectedRow == -1){
		self.currentNodes.tagsArray = nil;
		coverView.current = nil;
	}else{
		self.currentNodes.tagsArray = [[[directoryStack lastObject] children] 
									   objectsAtIndexes:[table selectedRowIndexes]];
		coverView.current = [self.currentNodes.tagsArray objectAtIndex:0];
		[previewPanel reloadData];
	}
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
	NSImage *indicatorImage;
	NSString * identifer = [tableColumn identifier];
	
	if ([currentColumnKey isEqualToString:identifer]){
		currentColumnAscending = !currentColumnAscending;
	}else{
		currentColumnAscending = NO;
		currentColumnKey = identifer;
		for (NSTableColumn *column in [tableView tableColumns]) {
			[tableView setIndicatorImage: nil
						   inTableColumn: column];
		}
	}
	
	[tableView setHighlightedTableColumn:tableColumn];
	[[directoryStack lastObject] sort:currentColumnKey
							ascending:currentColumnAscending];
	
	if (currentColumnAscending){
		indicatorImage = [NSImage imageNamed: @"NSAscendingSortIndicator"];		
	}else{
		indicatorImage = [NSImage imageNamed: @"NSDescendingSortIndicator"];	
	}
	
	[tableView setIndicatorImage: indicatorImage
                   inTableColumn: tableColumn];
	[table reloadData];
}

// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
	 toPasteboard:(NSPasteboard*)pboard
{
    // Copy the row numbers to the pasteboard.
    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:TABLE_VIEW_ROW_TYPE] owner:self];
    [pboard setData:zNSIndexSetData forType:TABLE_VIEW_ROW_TYPE];
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
    NSData* rowData        = [pboard dataForType:TABLE_VIEW_ROW_TYPE];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow      = [rowIndexes firstIndex];
	
	FileSystemNode *from =  [self nodeAtIndex:dragRow] , *to =[self nodeAtIndex:row];
	if (![to hasBasicMetadata] || ![from hasBasicMetadata]){
		return NO;
	}
	
	
	
	const IntPair *ip =[[IntPair alloc] initWithInts:dragRow second:row];
	if (operation == NSTableViewDropOn){
		NSBeginAlertSheet(@"Copy Tags?",
						  @"Yes", 
						  @"No", 
						  nil, 
						  window,
						  self, 
						  @selector(copyTags:returnCode:contextInfo:),
						  NULL, 
						  (__bridge_retained void*)ip,
						  [NSString stringWithFormat:
						   @"Copy Tags? (artwork is not copied) from \n%@ to \n%@",
						   [from.tags displayName], [to.tags displayName]]
						  );
		
		return NO;
	}
	
    // Move the specified row to its new location...
	// if we remove a row then everything moves down by one
	// so do an insert prior to the delete
	if (dragRow < row) {
		[[directoryStack lastObject] swapChildrenAtIndex:row from:dragRow removeFirst:NO];		
		[self.table noteNumberOfRowsChanged];
		[self.table reloadData];
		
		return YES;
		
	}
	[[directoryStack lastObject] swapChildrenAtIndex:row from:dragRow removeFirst:YES];
	[self.table noteNumberOfRowsChanged];
	[self.table reloadData];
	
	return YES;
}

- (void) copyTags:(NSWindow *)sheet 
	   returnCode:(int)returnCode 
	  contextInfo:(IntPair*)pair;
{
	if (returnCode == NSAlertDefaultReturn){
		DDLogInfo(@"selected yes %zd %zd",pair.first, pair.second);
		
		Tags *from = ([self nodeAtIndex:pair.first]).tags;
		Tags *to   = ([self nodeAtIndex:pair.second]).tags;
		const NSSet *keys = [[NSSet alloc ] initWithObjects:
						 @"title",  @"album",  @"artist", @"composer", @"year",
						 @"track",  @"disc",   @"genre",  @"albumArtist", 
						 @"comment", @"grouping", @"totalTracks", @"totalDiscs",
						 @"compilation",@"url",
						 nil];
		
		for (NSString *key in keys) {
			[to setValue:[from valueForKey:key] forKey:key];
		}
		[table setNeedsDisplayInRect:[table rectOfRow:pair.second]];
	}
	//CFRelease(pair);
}



// Jump to the corrent row in the table based on the keypress
- (BOOL) tableView:(NSTableView *)tableView
	   willKeyDown:(NSEvent *)event{
	if ( [event timestamp] - lastKeyPress > 0.3 ){
		currentEventString  = [event charactersIgnoringModifiers];
	}else{
		currentEventString  = [currentEventString stringByAppendingString:[event charactersIgnoringModifiers]];
	}
	lastKeyPress = [event timestamp];
	
	if (isalnum([currentEventString characterAtIndex:0 ])) {
		NSObject <NSTableViewDataSource> *source = [tableView dataSource];
		NSUInteger len = [tableView numberOfRows];
		NSTableColumn *first = [tableView tableColumnWithIdentifier:@"filename"];
		
		DDLogVerbose(@"currentEventString %@", currentEventString);
		NSUInteger i;
		for(i = 0; i < len; ++i){
			id  obj = [source tableView:tableView  objectValueForTableColumn:first row:i];
			if ([obj isKindOfClass:[NSString class]]){
				if ([[obj lowercaseString] hasPrefix:currentEventString]){
					[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
					[tableView scrollRowToVisible:i];
					return YES;
				}
			}
		}
		
	}
	return NO;
}

#pragma mark - SplitView

// this is the handler the above snippet refers to
- (void) splitViewWillResizeSubviewsHandler:(id)object
{
    lastSplitViewSubViewRightWidth = [rightSplitView frame].size.width;
}

// expanded/collapsed the right SplitView
- (IBAction) toggleRightSubView:(id)sender
{
    if ([splitView isSubviewCollapsed:rightSplitView]){
		DDLogVerbose(@"");
		[rightSplitView setHidden:NO];
        [splitView setPosition:lastSplitViewSubViewRightWidth
			  ofDividerAtIndex:0];
    }else{
		DDLogVerbose(@"");
		[splitView setPosition:[splitView maxPossiblePositionOfDividerAtIndex:0]
			  ofDividerAtIndex:0];
		[rightSplitView setHidden:YES];
	}
}


#pragma mark - Directory Manipulation Methods

-(IBAction)goToParentMenu:(id)sender
{
	if ([parentNodes count] >=2){
		self.selectedNodeindex = [NSNumber numberWithInt:1];
		[self goToParent:popup];	
	}
}


-(IBAction)goToParent:(id)sender
{
	DDLogVerbose(@"i:%@ pN:%@", selectedNodeindex, [parentNodes objectAtIndex:[selectedNodeindex intValue]]);
	int index = [selectedNodeindex intValue];
	if (index == 0) {
		return;
	}
	
	// remove all the child elements
	int i;
	for (i =0; i < index; ++i) {
		[parentNodes removeObjectAtIndex:0];
		[popup  removeItemAtIndex:0];
	}
	
	//Refresh the gui
	self.selectedNodeindex = [NSNumber numberWithInt:0];
	
	[directoryStack addObject:[parentNodes objectAtIndex:0]];
	DDLogInfo(@"directoryStack %@", directoryStack);
	[table deselectAll:self];
	[table reloadData];
	[self _vgmdbEnable];
	[self _vgmdbEnableDir];
	[window setTitleWithRepresentedFilename:[[[directoryStack lastObject] URL ] path]];
}

- (void)setPopupMenuIcons
{
	int i =0; 
	for (i=0; i< [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}
}

- (IBAction)open:(id)sender
{
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanChooseDirectories:YES];
    if ([op runModal] != NSOKButton) return;
    
	[self goToDirectory:[op URL]];
}

- (void)goToDirectory:(NSURL*)url
{
	DDLogInfo(@"%@ selected", url);
	FileSystemNode *node  = [[FileSystemNode alloc ] initWithURL:url];
	[parentNodes removeAllObjects];
	[parentNodes addObjectsFromArray:[node parentNodes] ];
	
 	[directoryStack addObject:node];
	[table deselectAll:self];
	[table reloadData];
	
	NSInteger popupCount = [popup numberOfItems];
	NSInteger min = MIN([parentNodes count], popupCount);
	DDLogVerbose(@"min:%zu pN:%zu popN:%zu", min, [parentNodes count], popupCount); 
	
	// Correct the number of items in the popupmenu
	NSInteger i;
	for (i=min; i < [parentNodes count]; ++i) {
		[popup addItemWithTitle:[[NSNumber numberWithLong:i] stringValue] ];
		DDLogVerbose(@"pN:%zu popN:%zu", [parentNodes count], [popup numberOfItems]);
	}	
	
	for (i=min; i < popupCount; ++i) {
		[popup removeItemAtIndex:0];
	}
	
	for (i=0; i < [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setTitle:[[parentNodes objectAtIndex:i] displayName]];
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}	
	[self _vgmdbEnable];
	[self _vgmdbEnableDir];
	[window setTitleWithRepresentedFilename:[url path]];
}

- (IBAction)backForwordDirectories:(id)sender
{
	DDLogVerbose(@"backForwordDirectories");
    NSInteger tag = [[sender cell] tagForSegment:[sender selectedSegment]];
	DDLogVerbose(@"tag :%zd  ds %zd fs %zd", tag,  [directoryStack count],[forwardStack count] );
	
	if (tag == 0){
		[self backDirectories:sender];		
	}else if (tag == 1){
		[self forwordDirectories:sender];
	}
	
}

- (void)backForwordDirectoriesCommon
{
	self.parentNodes = [[directoryStack lastObject] parentNodes];
	DDLogVerbose(@"%@ bf parentNodes %@", [[directoryStack lastObject] displayName], parentNodes);
	
	[self setPopupMenuIcons];
	self.selectedNodeindex = [NSNumber numberWithInt:0];
	DDLogVerbose (@"directoryStack %@", directoryStack);
	[table deselectAll:self];
	[table reloadData];
	[self _vgmdbEnable];
	[self _vgmdbEnableDir];
	[window setTitleWithRepresentedFilename:[[[directoryStack lastObject] URL ] path]];
}

- (IBAction)backDirectories:(id)sender
{
	if ( [directoryStack count] >= 2){
		[forwardStack addObject:[directoryStack pop]];
		[self backForwordDirectoriesCommon];	
	}
}

- (IBAction)forwordDirectories:(id)sender
{
	if ( [forwardStack count] >= 1){
		[directoryStack addObject:[forwardStack pop]];
		[self backForwordDirectoriesCommon];	
	}
}

- (IBAction)goToPredefinedDirectory:(id)sender
{
	[self goToDirectory:[predefinedDirectories objectAtIndex:[sender tag]]];
}

- (IBAction)goToStartingDirectory:(id)sender
{
	[self goToDirectory: [[NSUserDefaults standardUserDefaults] URLForKey:@"startUrl"]];
}

#pragma mark - External Applications

- (IBAction)addSelectedToItunes:(id)sender
{	
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	iTunesTrack * track = [iTunes add:[NSArray arrayWithObject:currentNodes.urls] 
								   to:nil];
	DDLogRelease(@"Added %@ to track: %@",currentNodes.urls,track);
}

- (IBAction)revealInFinder:(id)sender
{
	for (FileSystemNode *n in currentNodes.tagsArray) {
		[[NSWorkspace sharedWorkspace] selectFile:[n.URL path] 
						 inFileViewerRootedAtPath:nil];
	}
}

- (IBAction)openHomePage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://bilalh.github.com/projects/tagger/"]]; 	
}

- (IBAction)openDonate:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AMLSQBUQ8E8RE"]];
}

- (IBAction)openIssues:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/Bilalh/Tagger/issues"]]; 	
}

#pragma mark - Tag Manipulation

- (IBAction)capitalisedTags:(id)sender
{
	[self performBlockOnTags:sender tagNames:tagMenuValues block:^id (id value, NSString *tagName, Tags *tags) {
		return [value capitalizedString];
	}];
}

- (IBAction)lowercaseTags:(id)sender
{
	[self performBlockOnTags:sender tagNames:tagMenuValues block:^id (id value, NSString *tagName, Tags *tags) {
		return [value lowercaseString];
	}];
}


- (IBAction)uppercaseTags:(id)sender
{
	[self performBlockOnTags:sender tagNames:tagMenuValues block:^id (id value, NSString *tagName, Tags *tags) {
		return [value uppercaseString];
	}];
}

- (IBAction)trimWhitespace:(id)sender
{
	[self performBlockOnTags:sender tagNames:tagMenuValues block:^id (id value, NSString *tagName, Tags *tags) {
		return [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
	}];
}

- (IBAction)deleteTag:(id)sender
{
	[self performBlockOnTags:sender tagNames:deleteMenuValues block:^id (id value, NSString *tagName, Tags *tags) {
		return nil;
	}];
	[self refresh:sender];
}

- (IBAction)deleteAllTags:(id)sender;
{
	[currentNodes deleteAllTags];
	[self refresh:sender];
}

- (IBAction)performBlockOnTags:(id)sender
					  tagNames:(const NSArray*)tagNames
						 block:(id (^)(id value, NSString *tagName, Tags *tags ))block
{	
	if ([currentNodes empty]) return;
	if ([sender tag] >=0){
		[self.currentNodes performBlockOnTag:[tagNames objectAtIndex:[sender tag]] block:block];	
	}else{
		[self.currentNodes performBlockOnTags:tagNames block:block];
	}
	[table reloadData];
	NSIndexSet *rows = [table selectedRowIndexes];
	[table selectRowIndexes:[NSIndexSet indexSet] byExtendingSelection:NO];
	[table selectRowIndexes:rows byExtendingSelection:NO];
}

- (IBAction) swapFirstAndLastName:(id)sender
{
	
	if (currentNodes.empty) return;
	[currentNodes swapFirstAndLastName:[swapMenuValues objectAtIndex: [sender tag]]];
	self.currentNodes.tagsArray = [[[directoryStack lastObject] children] 
								   objectsAtIndexes:[table selectedRowIndexes]];
	[table reloadData];
}

#pragma mark - Tag Renaming/Finding

- (IBAction) renumberFiles:(id)sender
{
	if (currentNodes.empty) return;
	int i = 0;
	
	BOOL hasTrackTotal = NO;
	
	for (FileSystemNode *n in currentNodes.tagsArray) {
		i++;
		n.tags.track = [NSNumber numberWithInt:i];
		if (n.tags.totalTracks) hasTrackTotal = YES;
	}
	
	if (!hasTrackTotal){
		for (FileSystemNode *n in currentNodes.tagsArray) {
			n.tags.totalTracks = [NSNumber numberWithInt:i];
		}
	}
	
}

- (IBAction)rename:(id)sender
{
	DDLogInfo(@"rename");
	
	rfc = [[RenamingFilesController alloc] initWithNodes:currentNodes 
												selector:@selector(renameWithFormatArray:)
											 buttonTitle:@"Rename" ];
		
	[NSApp beginSheet: [rfc window]
	   modalForWindow: self.window
		modalDelegate: rfc 
	   didEndSelector: @selector(didEndSheet:returnCode:result:)
		  contextInfo: (__bridge void *)(self)];
}

- (IBAction)renameWithPredefinedFormat:(id)sender
{
	DDLogVerbose(@"format array %@",[predefinedRenameFormats objectAtIndex:[sender tag]]);
	[currentNodes renameWithFormatArray: [predefinedRenameFormats objectAtIndex:[sender tag]]];
	[[directoryStack lastObject] invalidateChildren];
	[table reloadData];
}



- (IBAction)tagsFromFilename:(id)sender
{
	DDLogInfo(@"tagsFromFileName");
	
	rfc = [[RenamingFilesController alloc] initWithNodes:currentNodes 
												selector:@selector(tagsWithFormatArrayFromFilename:)
											 buttonTitle:@"Tag" ];
	
	[NSApp beginSheet: [rfc window]
	   modalForWindow: self.window
		modalDelegate: rfc 
	   didEndSelector: @selector(didEndSheet:returnCode:result:)
		  contextInfo: (__bridge void *)(self)];
}


- (IBAction)tagWithPredefinedFormat:(id)sender
{
	DDLogVerbose(@"format array %@",[predefinedTagFormats objectAtIndex:[sender tag]]);
	[currentNodes tagsWithFormatArrayFromFilename: [predefinedRenameFormats objectAtIndex:[sender tag]]];
	[self refresh:sender];
}

#pragma mark - Vgmdb

- (IBAction)search:(id)sender
{
	if (vgc == nil){
		vgc = [[VgmdbController alloc] initWithFiles:[[directoryStack lastObject] children]
											   table:table];	
	}else{
		[vgc reset:[[directoryStack lastObject] children]];	
	}
	[NSApp beginSheet: [vgc window]
	   modalForWindow: self.window
		modalDelegate: vgc 
	   didEndSelector: @selector(didEndSheet:returnCode:mainWindow:)
		  contextInfo: (__bridge void *)(self.window)];
	[table reloadData];
}

- (IBAction)searchWithSubDirectories:(id)sender
{
	NSMutableArray *nodes = [[NSMutableArray alloc] init ];
	for (FileSystemNode *n in [[directoryStack lastObject] children]) {
		if (n.isDirectory){
			[nodes addObjectsFromArray:n.children];
		}
	}
	
	if (vgc == nil){
		vgc = [[VgmdbController alloc] initWithFiles:nodes
											   table:table];	
	}else{
		[vgc reset:nodes];	
	}
	
	[NSApp beginSheet: [vgc window]
	   modalForWindow: self.window
		modalDelegate: vgc 
	   didEndSelector: @selector(didEndSheet:returnCode:mainWindow:)
		  contextInfo: (__bridge void *)(self.window)];
	[table reloadData];
}


#pragma mark - Gui Bools

- (BOOL)forwordStackEnable
{
	return [forwardStack count ] != 0;
}

- (BOOL)backwordStackEnable
{
	return [directoryStack count ] >=2;
}

- (void)_vgmdbEnable
{
	for (FileSystemNode *n in [[directoryStack lastObject] children] ) {
		if (!n.isDirectory) {
			_vgmdbEnable = YES;
			[vgmdbItem setEnabled:YES];
			return;
		}
	}
	_vgmdbEnable = NO;	
	[vgmdbItem setEnabled:NO];
}

- (void)_vgmdbEnableDir
{
	for (FileSystemNode *n in [[directoryStack lastObject] children] ) {
		if (n.isDirectory) {
			_vgmdbEnableDir = YES;
			return;
		}
	}
	_vgmdbEnableDir = NO;
}

- (BOOL)openEnable
{
	NSUInteger row =[table selectedRow];
	if (row == -1) return false;
	return [[[[directoryStack lastObject] children] objectAtIndex:row] isDirectory];
}

- (IBAction)reopen:(id)sender
{
	[self showWindow:self];
}

#pragma mark - QuickLook

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel;
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    previewPanel = panel;
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    previewPanel = nil;
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
	return [currentNodes.tagsArray count]; 
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel 
				previewItemAtIndex:(NSInteger)index
{
	return [currentNodes.tagsArray objectAtIndex:index];
}

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)item
{
    SEL action = [item action];
    if (action == @selector(togglePreviewPanel:)) {
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [(NSMenuItem*)item setTitle:@"Close Quick Look panel"];
        } else {
            [(NSMenuItem*)item setTitle:@"Open Quick Look panel"];
        }
        return YES;
    }
    return YES;
}

#pragma mark - Quicklook Delegate
- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event
{
    // redirect all key down events to the table view
    if ([event type] == NSKeyDown) {
        [table keyDown:event];
        return YES;
    }
    return NO;
}

#pragma mark - Windows

- (BOOL)windowShouldClose:(NSNotification *)notification
{
	[window orderOut:self];
	return NO;
}



#pragma mark - Helper Methods
- (FileSystemNode*) nodeAtIndex:(NSInteger)row
{
	return [[[directoryStack lastObject] children] objectAtIndex:row];
}

- (NSArray*) children
{
	return [[directoryStack lastObject] children];
}

- (IBAction)refresh:(id)sender
{
	[[directoryStack lastObject] invalidateChildren];
	[table reloadData];
}

#pragma mark - Alloc/init

- (void)awakeFromNib
{	
	[self setPopupMenuIcons];
	[table setDoubleAction:@selector(onClick:)];
	[[table tableColumnWithIdentifier:@"filename"] setEditable:false];
	[[table tableColumnWithIdentifier:@"title"] setEditable:true];
	[table setTarget:self];
	[self _vgmdbEnable];
	[self _vgmdbEnableDir];
	[table setMenu:[self labelMenu]];
	[table registerForDraggedTypes:[[table registeredDraggedTypes ] arrayByAddingObject:TABLE_VIEW_ROW_TYPE]];
	
	[self initTagManipulationSubMenus];
	[self initGoMenuItems];
	
//	Splitview stuff
	lastSplitViewSubViewRightWidth = [rightSplitView frame].size.width;
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(splitViewWillResizeSubviewsHandler:)
	 name:NSSplitViewWillResizeSubviewsNotification
	 object:splitView];	
}

-(void)initDirectoryTable
{
	directoryStack = [[NSMutableArray alloc] init];
	forwardStack   = [[NSMutableArray alloc] init];
	
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
										[[NSUserDefaults standardUserDefaults] URLForKey:@"startUrl"]];
	[directoryStack push:currentDirectory];
	
	currentNodes      = [[FileSystemNodeCollection alloc] init];
	selectedNodeindex = [NSNumber numberWithInt:0];
	parentNodes            = [currentDirectory parentNodes];
	
	DDLogVerbose(@"Staring parentNodes%@", parentNodes);
}

- (void) initTagManipulationSubMenus 
{
	void (^makeMenu)(const NSArray*, NSMenu*, SEL) = ^(const NSArray *titles, NSMenu *menu, SEL action){
		int i;
		for (i =0; i < [titles count]; ++i) {
			NSMenuItem *item = [[NSMenuItem alloc] initWithTitle: [[titles objectAtIndex:i] capitalizedString]
														  action:action
												   keyEquivalent:@""];
			[item setTag:i];
			[item bind:@"enabled" 
			  toObject:self 
		   withKeyPath:@"currentNodes.hasBasicMetadata" 
			   options:nil];
			[menu addItem:item];
		}
	};
	
	makeMenu([[NSUserDefaults standardUserDefaults] arrayForKey:@"predefinedRenameFormatsTitles"],
			 renameMenu,
			 @selector(renameWithPredefinedFormat:));
	
	makeMenu([[NSUserDefaults standardUserDefaults] arrayForKey:@"predefinedTagFormatsTitles"],
			 tagMenu,
			 @selector(tagWithPredefinedFormat:));
	
	makeMenu(tagMenuValues, capitaliseMenu, @selector(capitalisedTags:));
	makeMenu(tagMenuValues, uppercaseMenu,  @selector(uppercaseTags:));
	makeMenu(tagMenuValues, lowercaseMenu,  @selector(lowercaseTags:));
	makeMenu(tagMenuValues, whitespaceMenu, @selector(trimWhitespace:));
	makeMenu(deleteMenuValues, deleteMenu,  @selector(deleteTag:));
	makeMenu(swapMenuValues, swapMenu,  @selector(swapFirstAndLastName:));
	
	NSMenuItem *item = [swapMenu itemAtIndex:0];
	[item setKeyEquivalent:@"p"];
	[item setKeyEquivalentModifierMask:NSCommandKeyMask | NSShiftKeyMask];


}

- (void) initGoMenuItems
{
	void (^setIcon)(NSMenuItem*, OSType) = ^(NSMenuItem* item, OSType type){
		NSString *fileType = NSFileTypeForHFSTypeCode(type);
		NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFileType:fileType];
		[icon setSize:NSMakeSize(16, 16)];
		[item setImage:icon];
	};
	setIcon(computerMenuItem, kComputerIcon);
	setIcon(desktopMenuItem,  kToolbarDesktopFolderIcon);
	setIcon(downloadMenuItem, kToolbarDownloadsFolderIcon);
	setIcon(homeMenuItem,     kToolbarHomeIcon);
	setIcon(musicMenuItem,    kToolbarMusicFolderIcon);
	setIcon(movieMenuItem,    kToolbarMovieFolderIcon);
}

- (id)init
{
    self = [super init];
    if (self) {
		[self initDirectoryTable ];
		lastKeyPress = 0;
		currentEventString = [[NSString alloc] init];
    }
	
    return self;
}

+ (void)initialize
{
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"Vgmdb" ofType:@"rb"];
//	[[MacRuby sharedRuntime] evaluateFileAtPath:path];
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:
															 [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"]]];	
	[[NSUserDefaults standardUserDefaults]  synchronize];
	
	predefinedDirectories = [[NSArray alloc] initWithObjects:
							 [NSURL fileURLWithPath:[@"/" stringByExpandingTildeInPath] 
										isDirectory:YES],
							 [NSURL fileURLWithPath:[@"~" stringByExpandingTildeInPath]
										isDirectory:YES],
							 [NSURL fileURLWithPath:[@"~/Desktop" stringByExpandingTildeInPath]
										isDirectory:YES],
							 [NSURL fileURLWithPath:[@"~/Downloads" stringByExpandingTildeInPath]
										isDirectory:YES],
							 [NSURL fileURLWithPath:[@"~/Music"stringByExpandingTildeInPath]
										isDirectory:YES],
							 [NSURL fileURLWithPath:[@"~/Movies"stringByExpandingTildeInPath]
										isDirectory:YES],
							 nil];
	
	predefinedRenameFormats = [[NSUserDefaults standardUserDefaults] arrayForKey:@"predefinedRenameFormats"];
	predefinedTagFormats    = [[NSUserDefaults standardUserDefaults] arrayForKey:@"predefinedTagFormats"];
	tagMenuValues = [[NSArray alloc ] initWithObjects:
					 @"title",  @"album",  @"artist",@"albumArtist", @"composer", @"genre",
					 nil];
	
	deleteMenuValues = [[NSArray alloc ] initWithObjects:
					 @"title",  @"album",  @"artist",@"albumArtist", @"composer", @"genre", @"cover", @"comment", @"url",
					 nil];

	swapMenuValues = [[NSArray alloc ] initWithObjects:
					  @"artist",@"albumArtist", @"composer",
					  nil];
	
}



@end
