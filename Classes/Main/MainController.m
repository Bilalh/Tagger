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

#import "iTunes.h"
#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);


static const NSArray *predefinedDirectories;
static const NSArray *predefinedRenameFormats;

@interface MainController()  

- (void) initDirectoryTable;
- (void) setPopupMenuIcons;

- (void) backForwordDirectoriesCommon;

- (NSString *)stringFromFileSize:(NSInteger)size;

- (IBAction)renameWithPredefinedFormat:(id)sender;

- (void) openDirectoryNode: (FileSystemNode *) node;

/// Checks if there any music files
- (void) _vgmdbEnable;

/// Change the current directory to the clicked entries
- (IBAction) onClick:(id)sender;
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
@synthesize vgmdbEnable=_vgmdbEnable;
@dynamic forwordStackEnable, backwordStackEnable;

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
			return;
		}
	}
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
    return [[[directoryStack lastObject] children] count];
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

#pragma mark - Table Delegate
- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	NSArray *children = [[directoryStack lastObject] children];
	FileSystemNode *node = [children objectAtIndex:rowIndex];
	
	
	if ( [[aTableColumn identifier] isEqualToString:@"filename"] ){
		return [node displayName];
	}else if ([node isDirectory]){
		return @"";
	}else if ([[aTableColumn identifier] isEqualToString:@"size"]){
		return [self stringFromFileSize:[[node size] integerValue]];
	}else if ([[aTableColumn identifier] isEqualToString:@"trackPair"]){
		return [NSString stringWithFormat:@"%@ of %@",node.tags.track, node.tags.totalTracks];
	}else if ([[aTableColumn identifier] isEqualToString:@"discPair"]){
		return [NSString stringWithFormat:@"%@ of %@",node.tags.disc, node.tags.totalDiscs];
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
//		[cell setTextColor:[node labelColor]];
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

#pragma mark -
#pragma mark Directory Manipulation Methods

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
	[self _vgmdbEnable];
	[table deselectAll:self];
	[table reloadData];
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
	[self _vgmdbEnable];
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
	[self _vgmdbEnable];
	[table deselectAll:self];
	[table reloadData];
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

#pragma mark -
#pragma mark Gui Callback
- (IBAction)addSelectedToItunes:(id)sender
{	
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	iTunesTrack * track = [iTunes add:[NSArray arrayWithObject:currentNodes.urls] 
								   to:nil];
	NSLog(@"Added %@ to track: %@",currentNodes.urls,track);
}

- (IBAction)goToPredefinedDirectory:(id)sender
{
	[self goToDirectory:[predefinedDirectories objectAtIndex:[sender tag]]];
}

- (IBAction)goToStartingDirectory:(id)sender
{
	[self goToDirectory: [[NSUserDefaults standardUserDefaults] URLForKey:@"startUrl"]];
}

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
		  contextInfo: self.window];
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
		  contextInfo: self.window];
	[table reloadData];
}

- (IBAction)refresh:(id)sender
{
	[[directoryStack lastObject] invalidateChildren];
}

- (IBAction)rename:(id)sender
{
	if (!currentNodes.hasExtenedMetadata) return;
	DDLogInfo(@"rename");
	
	if (rfc)  [rfc release];
	rfc = [[RenamingFilesController alloc] initWithNodes:currentNodes];
		
	[NSApp beginSheet: [rfc window]
	   modalForWindow: self.window
		modalDelegate: rfc 
	   didEndSelector: @selector(didEndSheet:returnCode:result:)
		  contextInfo: [directoryStack lastObject]];
	//TODO 	put in didEndSheet
	[table reloadData];
}

- (IBAction)renameWithPredefinedFormat:(id)sender
{
	DDLogVerbose(@"format array %@",[predefinedRenameFormats objectAtIndex:[sender tag]]);
	[currentNodes renameWithFormatArray: [predefinedRenameFormats objectAtIndex:[sender tag]]];
	[[directoryStack lastObject] invalidateChildren];
	[table reloadData];
}

- (IBAction)revealInFinder:(id)sender
{
	for (FileSystemNode *n in currentNodes.tagsArray) {
		[[NSWorkspace sharedWorkspace] selectFile:[n.URL path] 
								inFileViewerRootedAtPath:nil];
	}
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

- (BOOL)openEnable
{
	NSUInteger row =[table selectedRow];
	if (row == -1) return false;
	return [[[[directoryStack lastObject] children] objectAtIndex:row] isDirectory];
}


#pragma mark - Windows

- (BOOL)windowShouldClose:(NSNotification *)notification
{
	[window orderOut:self];
	return NO;
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
    previewPanel = [panel retain];
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    [previewPanel release];
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


#pragma mark - Alloc/init

- (void)awakeFromNib
{	
	[self setPopupMenuIcons];
	[table setDoubleAction:@selector(onClick:)];
	[[table tableColumnWithIdentifier:@"filename"] setEditable:false];
	[[table tableColumnWithIdentifier:@"title"] setEditable:true];
	[table setTarget:self];
	[self _vgmdbEnable];
	
	NSArray *titles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"predefinedRenameFormatsTitles"];
	int i;
	for (i =0; i < [titles count]; ++i) {
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[titles objectAtIndex:i] 
													  action:@selector(renameWithPredefinedFormat:) 
											   keyEquivalent:@""];
		[item setTag:i];
		[item bind:@"enabled" 
		  toObject:self 
	   withKeyPath:@"currentNodes.hasBasicMetadata" 
		   options:nil];
		[renameMenu addItem:item];
	}
	
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

- (id)init
{
    self = [super init];
    if (self) {
		[self initDirectoryTable ];
    }
	
    return self;
}

+ (void)initialize
{
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
}

- (void)dealloc
{
    [super dealloc];
}


@end
