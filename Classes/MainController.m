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

@interface MainController()

-(void) initDirectoryTable;

@property (assign) NSMutableArray *directoryStack;
@end

@implementation MainController
@synthesize window, directoryStack;

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
//	[aTableColumn identifier]
	
	NSArray *children = [[directoryStack lastObject] children];
	NSImage *icon = [[children objectAtIndex:rowIndex] icon];
	[icon setSize:NSMakeSize(16, 16)];
	
	NSString *name = [[children objectAtIndex:rowIndex] displayName];

	NSTextAttachment *attachment;
    attachment = [[[NSTextAttachment alloc] init] autorelease];
	
    NSCell *cell = (NSCell*) [attachment attachmentCell]; // cast to quiet compiler warning
    [cell setImage: icon];
	
    NSAttributedString *attrname;
    attrname = [[NSAttributedString alloc] initWithString: name];
	
    NSMutableAttributedString *prettyName;
	// cast to quiet compiler warning
    prettyName = (id)[NSMutableAttributedString attributedStringWithAttachment:attachment]; 
    [prettyName appendAttributedString: attrname];
	
    return prettyName;	
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
}


#pragma mark -
#pragma mark Gui Callback

- (IBAction) open:(id)sender
{
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
						[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/higher"]];
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
#pragma mark Alloc

-(void) initDirectoryTable
{
	directoryStack = [[NSMutableArray alloc] init];
	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
										[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/higher"]];
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