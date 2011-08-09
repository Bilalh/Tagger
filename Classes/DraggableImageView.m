//
//  DraggableImageView.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "DraggableImageView.h"

@implementation NSImageCell (DraggableImageView)
- (NSImage *)_scaledImage {
    return _scaledImage;
}
@end

@implementation DraggableImageView
@dynamic downEvent;

- (void)startDrag:(NSEvent *)event
{
	NSPasteboard *pboard;
	NSImage *dragImage;
    NSImage *scaledImage = [[self cell] objectValue];
    NSLog(@"%@", scaledImage);
	NSPoint dragPoint;
	
    dragPoint = NSMakePoint(
							([self bounds].size.width - [scaledImage size].width) / 2,
							([self bounds].size.height - [scaledImage size].height) / 2);
	
    pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType]  owner:self];
    [pboard setData:[[self image] TIFFRepresentation] forType:NSTIFFPboardType];
	
	
    dragImage = [[[NSImage alloc] initWithSize: [scaledImage size]]
				 autorelease];
    [dragImage lockFocus];
    [[[self cell] objectValue] dissolveToPoint: NSMakePoint(0,0)
									   fraction: .5];
    [dragImage unlockFocus];
	
    [self dragImage: dragImage
				 at: dragPoint
			 offset: NSMakeSize(0,0)
			  event:event
		 pasteboard:pboard
			 source: self
		  slideBack: YES];
}

- (BOOL)shouldDelayWindowOrderingForEvent:(NSEvent *)event
{
    // maybe make more discerning?!
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

- (void)mouseDown:(NSEvent *)event
{
    [self setDownEvent:event];
}

- (void)mouseDragged:(NSEvent *)event
{
    if ([self image]) {
        [self startDrag:downEvent];
	}
    [self setDownEvent:nil];
}

- (NSEvent *)downEvent
{
    return downEvent;
}
- (void)setDownEvent:(NSEvent *)event
{
    [downEvent autorelease];
    downEvent = [event retain];
}

@end
