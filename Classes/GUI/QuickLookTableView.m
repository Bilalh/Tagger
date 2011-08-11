//
//  QuickLookTableView.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "QuickLookTableView.h"
#import "VGTaggerAppDelegate.h"
#import "MainController.h"
#import "FileSystemNode.h"

@implementation QuickLookTableView

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* key = [theEvent charactersIgnoringModifiers];
    if([key isEqual:@" "]) {
        [[NSApp delegate] togglePreviewPanel:self];
    } else {
        [super keyDown:theEvent];
    }
}

// Override The row colour with the label colour for only the filename column.
// with nice rounded side if there is a label colour.
- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect;
{
	NSColor *colour = [[[[[(MainController*)[self dataSource] directoryStack] 
					   lastObject] children] 
	  objectAtIndex:row] labelColor];
	if (!colour){
		[super drawRow:row clipRect:clipRect];
		return;
	};
	
	[NSGraphicsContext saveGraphicsState];
	NSRectClip(clipRect);
	NSRect rowRect = [self rectOfRow:row];
	// colour only the filename column.
	NSRect colRect = [self rectOfColumn: [self columnWithIdentifier:@"filename"]];
	rowRect.size.width = colRect.size.width;
	rowRect.origin.x   = colRect.origin.x;

	
	// draw over the alternating row colour
	[[NSColor whiteColor] setFill];
	NSRectFill(NSIntersectionRect(rowRect, clipRect));
	// draw with rounded end caps
	CGFloat radius = NSHeight(rowRect) / 2.0;
	NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rowRect, 1.0, 0.0) 
													  xRadius:radius 
													  yRadius:radius];
	[colour setFill];
	[p fill];
	[NSGraphicsContext restoreGraphicsState];
	// draw cells on top of the new row background
	[super drawRow:row clipRect:clipRect];
}


@end
