//
//  DraggableImageView.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "DraggableImageView.h"

@interface DraggableImageView()
- (void)startDrag:(NSEvent *)event;
@end

@implementation DraggableImageView
@synthesize downEvent;

- (void)startDrag:(NSEvent *)event
{
	NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	
	[pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType]
				   owner:self];
	[pboard setData:[[self image] TIFFRepresentation] 
			forType:NSTIFFPboardType];
	
	BOOL writeAsFile = [[NSUserDefaults standardUserDefaults] boolForKey:@"writeDraggedImageAsFile"];
	
	if (writeAsFile){
		NSString *tempFileName = @"/tmp/cover.jpg";
		NSBitmapImageRep *bits= [[[self image] representations ] objectAtIndex:0];
		NSData *data = [bits representationUsingType: NSPNGFileType
										  properties: nil];
		[data writeToFile: tempFileName
			   atomically: NO];
		
		[pboard addTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:self];
		[pboard setPropertyList:[NSArray arrayWithObject:tempFileName] 
						forType:NSFilenamesPboardType];
	}
	
	NSImage *scaledImage = [[self cell] objectValue];
	NSImage *dragImage = [[[NSImage alloc] initWithSize: [scaledImage size]] autorelease];
    [dragImage lockFocus];
    [[[self cell] objectValue] dissolveToPoint: NSMakePoint(0,0)
									  fraction: .5];
    [dragImage unlockFocus];
	
	NSPoint dragPoint = NSMakePoint(
									([self bounds].size.width - [scaledImage size].width) / 2,
									([self bounds].size.height - [scaledImage size].height) / 2);
	
    [self dragImage:dragImage
                 at:dragPoint
             offset:NSZeroSize
              event:event
         pasteboard:pboard
             source:self
          slideBack:YES];
}

- (BOOL)shouldDelayWindowOrderingForEvent:(NSEvent *)event
{
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

- (void)mouseDown:(NSEvent *)event
{
	self.downEvent = event;
}

- (void)mouseDragged:(NSEvent *)event
{
    if ([self image]) {
        [self startDrag:self.downEvent];
	}
	self.downEvent = nil;
}

@end
