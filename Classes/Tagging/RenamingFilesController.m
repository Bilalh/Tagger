//
//  RenamingFiles.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 01/08/2011.
//  Copyright 2011  All rights reserved.
//

#import "RenamingFilesController.h"
#import "FileSystemNodeCollection.h"
#import "FileSystemNode.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);

static const NSSet *tokensSet;

@implementation RenamingFilesController
@synthesize tokenField;

#pragma mark -
#pragma mark init

- (id)initWithNodes:(FileSystemNodeCollection*)newNodes
{
	self = [super initWithWindowNibName:@"RenameDisplay"];
    if (self) {
		nodes = newNodes;
    }
	
    return self;
}

+ (void) initialize
{
	tokensSet = [[NSSet alloc ] initWithObjects:
				 @"title",  @"album",  @"artist", @"composer", @"year",
				 @"track",  @"disc",   @"genre",  @"albumArtist",
				 nil];
}


#pragma mark -
#pragma mark Tagging

- (IBAction)tagFiles:(id)sender
{
	DDLogInfo(@"Obj %@", [tokenField objectValue]);
	NSError *res = [nodes renameWithFormatArray:[tokenField objectValue]];
	DDLogInfo(@"res:%@", res ? [res localizedDescription] : nil);
	[self confirmSheet:self];
}

#pragma mark -
#pragma mark Token Field Delegate

// capitalized tokens
- (NSString *)          tokenField:(NSTokenField *)tokenField 
 displayStringForRepresentedObject:(id)representedObject
{
	return [representedObject capitalizedString];
}

// Only highlight predefined tokens
- (NSTokenStyle)tokenField:(NSTokenField *)tokenField
 styleForRepresentedObject:(id)representedObject
{
	if ([tokensSet containsObject:representedObject]) {
		return NSRoundedTokenStyle;	
	}else{
		return NSPlainTextTokenStyle;	
	}
}

// Keeps the whitespace.
- (id)                  tokenField:(NSTokenField *)tokenField 
 representedObjectForEditingString:(NSString *)editingString
{
	return editingString;
}

// Do not let token be editable after they have been made.
- (NSString *)          tokenField:(NSTokenField *)tokenField 
 editingStringForRepresentedObject:(id)representedObject
{
	return nil;
}


#pragma mark -
#pragma mark Sheet Methods

- (void) didEndSheet:(NSWindow*)sheet 
		  returnCode:(int)returnCode
			  result:(FileSystemNode*)result
{	
	DDLogInfo(@"reanming End Sheet");
	if (returnCode == NSOKButton){
		[result invalidateChildren];
	}
	[sheet orderOut:self];
}

- (IBAction)cancelSheet:sender
{	
	DDLogInfo(@"Rename Cancel");
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}

- (IBAction)confirmSheet:sender
{
	DDLogInfo(@"Rename Comfirm");
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

@end
