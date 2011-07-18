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

-(void) initDirectoryTable;

@property (assign) NSMutableArray *directoryStack;
@end

@implementation MainController
@synthesize window, popup, directoryStack, parentNodes, selectedNode;

#pragma mark -
#pragma mark Table Methods 


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
#pragma mark Gui Callback

-(IBAction) goToParent:(id)sender
{
	NSLog(@"%@", selectedNode);
}

- (IBAction) open:(id)sender
{
}

- (IBAction) getData:(id)sender
{
	Tags *tl  = [[MP4Tags alloc] initWithFilename:@"/Users/bilalh/Programming/Projects/VGTagger/Test Files/aac.m4a"];
	[title setStringValue:tl.title];
	NSLog(@"%@",tl.year);
}

- (IBAction)onTextChange:(id)sender
{
	NSString *s = [sender stringValue] ;
	NSLog(@"Text is Now %@", s );
	if (s != @""){
		Tags *tl  = [[MP4Tags alloc] initWithFilename:@"/Users/bilalh/Programming/Projects/VGTagger/Test Files/aac.m4a"];
		[tl setTitle:s];
	}
	
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
	
	int i =0; 
	for (i=0; i< [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}
}

-(void) initDirectoryTable
{
	NSLog(@"initDirectoryTable");
	directoryStack = [[NSMutableArray alloc] init];
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
										[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/start"]];
	[directoryStack push:currentDirectory];
	parentNodes  = [currentDirectory parentNodes];
	selectedNode = [parentNodes objectAtIndex:0];
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