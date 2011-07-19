//
//  Controller.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MainController.h"
#import "Tags.h"
#import "MP4Tags.h"
#import "VgmdbController.h"
#import "DisplayController.h"
#import "FileSystemNode.h"
#import "NSMutableArray+Stack.h"
#import "ImageAndTextCell.h"

@interface MainController()

- (void) initDirectoryTable;
- (void) setPopupMenuIcons;

@end

@implementation MainController
@synthesize window, directoryStack;

#pragma mark -
#pragma mark Table Methods 


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
//	NSLog(@"numberOfRowsInTableView %@\n %zu", [directoryStack lastObject], [[[directoryStack lastObject] children] count]);
    return [[[directoryStack lastObject] children] count];
}

- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	NSArray *children = [[directoryStack lastObject] children];
//	NSLog(@"tableViewUpdate %@\t %zu", [directoryStack lastObject], [children count]);

	FileSystemNode *node = [children objectAtIndex:rowIndex];
	
	if ( [[aTableColumn identifier] isEqualToString:@"filename"] ){
		return [node displayName];
		
	}else if([node isDirectory]){
		return @"";
	}
	
	SEL selector = NSSelectorFromString([aTableColumn identifier]);
	return [node.tags performSelector:selector];
}


- (void)tableView:(NSTableView *)tableView 
  willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn
			  row:(NSInteger)rowIndex
{
	if ([[tableColumn identifier] isEqualToString:@"filename"]){
		NSArray *children = [[directoryStack lastObject] children];
		NSImage *icon = [[children objectAtIndex:rowIndex] icon];
		[icon setSize:NSMakeSize(16, 16)];
		[(ImageAndTextCell*)cell setImage: icon];		
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
}

#pragma mark -
#pragma mark Directory Manipulation Methods

-(IBAction) goToParent:(id)sender
{
	NSLog(@"i:%@ pN:%@", selectedNodeindex, [parentNodes objectAtIndex:[selectedNodeindex intValue]]);
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
	selectedNodeindex = [NSNumber numberWithInt:0];
	[directoryStack addObject:[parentNodes objectAtIndex:0]];
	NSLog(@"directoryStack %@", directoryStack);
	[table reloadData];
}

- (IBAction) open:(id)sender
{
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanChooseDirectories:YES];
    if ([op runModal] != NSOKButton) return;
    
	NSURL *url = [op URL];
	NSLog(@"%@", url);
	FileSystemNode *node  = [[FileSystemNode alloc ] initWithURL:url];
	[parentNodes removeAllObjects];
	[parentNodes addObjectsFromArray:[node parentNodes] ];
	
 	[directoryStack addObject:node];
	[table reloadData];

	NSInteger popupCount = [popup numberOfItems];
	NSInteger min = MIN([parentNodes count], popupCount);
	NSLog(@"min:%zu pN:%zu popN:%zu", min, [parentNodes count], popupCount);
	
	// Correct the number of items in the popupmenu
	NSInteger i;
	for (i=min; i < [parentNodes count]; ++i) {
		[popup addItemWithTitle:[[NSNumber numberWithLong:i] stringValue] ];
		NSLog(@"pN:%zu popN:%zu", [parentNodes count], [popup numberOfItems]);
	}	

	for (i=min; i < popupCount; ++i) {
		[popup removeItemAtIndex:0];
	}
	
	for (i=0; i < [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setTitle:[[parentNodes objectAtIndex:i] displayName]];
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}	
	
}

- (void) setPopupMenuIcons
{
	int i =0; 
	for (i=0; i< [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}
}

#pragma mark -
#pragma mark Gui Callback

- (IBAction) getData:(id)sender
{
	Tags *tl  = [[MP4Tags alloc] initWithFilename:@"/Users/bilalh/Programming/Projects/VGTagger/Test Files/aac.m4a"];
	[title setStringValue:tl.title];
	NSLog(@"%@",tl.year);
}

- (IBAction) search:(id)sender{
	if (vgc == nil){
		vgc = [[VgmdbController alloc] init];	
	}else{
		[vgc reset];	
	}
	
	[NSApp beginSheet: [vgc window]
	   modalForWindow: self.window
		modalDelegate: vgc 
	   didEndSelector: @selector(didEndSheet:returnCode:mainWindow:)
		  contextInfo: self.window]; 	
}

#pragma mark -
#pragma mark Alloc/init

-(void) awakeFromNib
{	
	[self setPopupMenuIcons];
}

-(void) initDirectoryTable
{
	NSLog(@"initDirectoryTable");
	directoryStack = [[NSMutableArray alloc] init];
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
										[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/start"]];
	[directoryStack push:currentDirectory];
	parentNodes  = [currentDirectory parentNodes];
	selectedNodeindex = [NSNumber numberWithInt:0];
	NSLog(@"%@", parentNodes);
	
}

- (id)init
{
    self = [super init];
    if (self) {
		[self initDirectoryTable ];
    }
	
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end