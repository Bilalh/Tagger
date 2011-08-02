//
//  RenamingFiles.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 01/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileSystemNodeCollection;
@class FileSystemNode;


@interface RenamingFilesController : NSWindowController {
@private
	IBOutlet NSWindow *window;
	FileSystemNodeCollection  *nodes;
}

@property (assign) IBOutlet NSTokenField *tokenField;


- (id)initWithNodes:(FileSystemNodeCollection*)newNodes;
- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;

- (IBAction)tagFiles:(id)sender;

@end
