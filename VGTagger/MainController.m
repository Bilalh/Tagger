//
//  Controller.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import "MainController.h"
#import "TagsLib.h"
#import "VgmdbController.h"

@implementation MainController

@synthesize title, window, vgc;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
	
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (IBAction)onTextChange:(id)sender
{
	NSString *s = [sender stringValue] ;
	NSLog(@"Text is Now %@", s );
	if (s != @""){
		TagsLib *tl  = [[TagsLib alloc] initWithFilename:@"/Users/bilalh/Programming/Cocoa/VGTagger/VGTagger/TestFiles/aac.m4a"];
		[tl setTitle:s];
	}
	
}

- (IBAction) getData:(id)sender
{
	TagsLib *tl  = [[TagsLib alloc] initWithFilename:@"/Users/bilalh/Programming/Cocoa/VGTagger/VGTagger/TestFiles/aac.m4a"];
	
	NSString *s  = [tl getTitle];
	NSLog(@"Title is %@", s);
	[title setStringValue:s];
}

- (IBAction) search:(id)sender{
	NSLog(@"Search");
	vgc = [[VgmdbController alloc] initWithWindowNibName:@"VgmdbSearch"];
	[vgc showWindow:self];
}

- (IBAction) sheet:(id)sender
{

	
//	id vgmdb = [[MacRuby sharedRuntime] evaluateString:@"Vgmdb.new"];
//	NSDictionary *result = [vgmdb performRubySelector:@selector(search:)
//										withArguments:@"a", nil];
//	NSDictionary *result = [vgmdb performRubySelector:@selector(get_data:)
//										withArguments:@"/Users/bilalh/Programming/Cocoa/VGTagger/VGTagger/TestFiles/test2.html", nil];
	
//	NSLog(@"hash %@", result);
}

@end