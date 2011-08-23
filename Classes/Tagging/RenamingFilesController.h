//
//  RenamingFiles.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 01/08/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileSystemNodeCollection;
@class FileSystemNode;


@interface RenamingFilesController : NSWindowController {
@private
	IBOutlet NSWindow *window;
	FileSystemNodeCollection  *nodes;
	SEL tagSelector;
}

@property (assign) IBOutlet NSTokenField *tokenField;
@property (assign) NSString *buttonTitle;

- (id)initWithNodes:(FileSystemNodeCollection*)newNodes
		   selector:(SEL)selector
		buttonTitle:(NSString*)title;

- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;

- (IBAction)tagFiles:(id)sender;

@end
