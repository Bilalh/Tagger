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
@synthesize window, directoryStack, table;

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
//	id a = [node.tags valueForKey:[aTableColumn identifier]]; 
//	NSLog(@"%@",a);
	return  node.tags.title;
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

- (IBAction) open:(id)sender
{
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
						[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/start"]];
	[self.directoryStack push:currentDirectory];

	NSArray *children = [currentDirectory children];
	NSLog(@"%lu", [directoryStack count]);
	NSLog(@"%@", [children objectAtIndex:0]);
}

- (IBAction) getData:(id)sender
{
	Tags *tl  = [[MP4Tags alloc] initWithFilename:@"/Users/bilalh/Programming/Projects/VGTagger/Test Files/aac.m4a"];
	[title setStringValue:tl.title];
	NSLog(@"%lu",tl.year);
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
//	NSTableColumn* tableColumn = [self.table tableColumnWithIdentifier: @"filename"];
//    ImageAndTextCell* imageAndTextCell = [[[ImageAndTextCell alloc] init] autorelease];
//    [imageAndTextCell setEditable: YES];
//    [tableColumn setDataCell:imageAndTextCell];
}

-(void) initDirectoryTable
{
	directoryStack = [[NSMutableArray alloc] init];
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
										[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/start"]];
	[self.directoryStack push:currentDirectory];
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