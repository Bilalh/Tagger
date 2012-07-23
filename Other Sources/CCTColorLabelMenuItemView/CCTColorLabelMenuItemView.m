/*

File: TrackView.m

Abstract: The NSView that handles the label color tracking.
Dan Messing
 
*/

#import "CCTColorLabelMenuItemView.h"

@implementation CCTColorLabelMenuItemView

@synthesize delegate, selectedLabel;

// key for dictionary in NSTrackingAreas's userInfo
NSString* kTrackerKey = @"whichTracker";

// key values for dictionary in NSTrackingAreas's userInfo,
// which tracking area is being tracked
// these correspond to CCTRowItem's enum values, and the two could be combined into one
// I've left them seperate here so as not to create any dependancies between this view and the model
enum trackingAreaIDs
{
	kTrackingAreaNone   = 0,
	kTrackingAreaRed    = 6,
	kTrackingAreaOrange = 7,
	kTrackingAreaYellow = 5,
	kTrackingAreaGreen  = 2,
	kTrackingAreaBlue   = 4,
	kTrackingAreaPurple = 3,
	kTrackingAreaGray   = 1
};


// -------------------------------------------------------------------------------
//	initWithFrame:
//
//	Setup the tracking areas for each colored dot.
// -------------------------------------------------------------------------------
- (id)initWithFrame:(NSRect)frameRect
{
	if ( (self = [super initWithFrame:frameRect]) )
	{
		blink = 0;
		delegate = nil;
		[self setupTrackingAreas];
	}
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------


// -------------------------------------------------------------------------------
//	Returns the rectangle corresponding to the tracking area.
// -------------------------------------------------------------------------------
- (NSRect)rectForColorViewAtIndex:(NSInteger)index
{
	NSRect returnRect = NSZeroRect;
	switch (index)
	{
		case kTrackingAreaNone:
			returnRect = NSMakeRect(20, 10, 16, 16);
			break;
			
		case kTrackingAreaRed:
			returnRect = NSMakeRect(44, 10, 16, 16);
			break;
			
		case kTrackingAreaOrange:
			returnRect = NSMakeRect(63, 10, 16, 16);
			break;
			
		case kTrackingAreaYellow:
			returnRect = NSMakeRect(82, 10, 16, 16);
			break;
			
		case kTrackingAreaGreen:
			returnRect = NSMakeRect(101, 10, 16, 16);
			break;
			
		case kTrackingAreaBlue:
			returnRect = NSMakeRect(120, 10, 16, 16);
			break;
			
		case kTrackingAreaPurple:
			returnRect = NSMakeRect(139, 10, 16, 16);
			break;
			
		case kTrackingAreaGray:
			returnRect = NSMakeRect(158, 10, 16, 16);
			break;
	}
	return returnRect;	
}


// -------------------------------------------------------------------------------
//	Returns the color gradient corresponding to the label. These colours were
//  chosen to appear similar to those in Aperture 3.
// -------------------------------------------------------------------------------

- (NSGradient *)gradientForLabel:(NSInteger)colorLabel
{
	NSGradient *gradient = nil;
	
	switch (colorLabel) {
		case kTrackingAreaNone:
			;
			break;
			
		case kTrackingAreaRed:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithDeviceRed:241.0/255.0 green:152.0/255.0 blue:139.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithDeviceRed:228.0/255.0 green:116.0/255.0 blue:102.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedRed:192.0/255.0 green:86.0/255.0 blue:73.0/255.0 alpha:1.0], 1.0, nil];
			break;
		case kTrackingAreaOrange:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithDeviceRed:248.0/255.0 green:201.0/255.0 blue:148.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithDeviceRed:237.0/255.0 green:174.0/255.0 blue:107.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedRed:210.0/255.0 green:143.0/255.0 blue:77.0/255.0 alpha:1.0], 1.0, nil];
			break;
		case kTrackingAreaYellow:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithDeviceRed:240.0/255.0 green:229.0/255.0 blue:164.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithDeviceRed:227.0/255.0 green:213.0/255.0 blue:119.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedRed:201.0/255.0 green:188.0/255.0 blue:92.0/255.0 alpha:1.0], 1.0, nil];
			break;
		case kTrackingAreaGreen:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithDeviceRed:209.0/255.0 green:236.0/255.0 blue:156.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithDeviceRed:175.0/255.0 green:215.0/255.0 blue:119.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedRed:142.0/255.0 green:182.0/255.0 blue:102.0/255.0 alpha:1.0], 1.0, nil];
			break;
		case kTrackingAreaBlue:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithDeviceRed:165.0/255.0 green:216.0/255.0 blue:249.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithDeviceRed:118.0/255.0 green:185.0/255.0 blue:232.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedRed:90.0/255.0 green:152.0/255.0 blue:201.0/255.0 alpha:1.0], 1.0, nil];
			break;
		case kTrackingAreaPurple:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithDeviceRed:232.0/255.0 green:191.0/255.0 blue:248.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithDeviceRed:202.0/255.0 green:152.0/255.0 blue:224.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedRed:163.0/255.0 green:121.0/255.0 blue:186.0/255.0 alpha:1.0], 1.0, nil];
			break;
		case kTrackingAreaGray:
			gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithCalibratedWhite:212.0/255.0 alpha:1.0], 0.0,
						[NSColor colorWithCalibratedWhite:182.0/255.0 alpha:1.0], 0.5,
						[NSColor colorWithCalibratedWhite:151.0/255.0 alpha:1.0], 1.0, nil];
			break;
			
		default:
			break;
	}
	
	return gradient;
}


// -------------------------------------------------------------------------------
//	setupTrackingAreas:
// -------------------------------------------------------------------------------
- (void)setupTrackingAreas
{
	if (trackingAreas == nil)
	{
		trackingAreas = [NSMutableArray array];	// keep all tracking areas in an array
		
		// determine the tracking options
		NSTrackingAreaOptions trackingOptions = NSTrackingEnabledDuringMouseDrag |
												NSTrackingMouseEnteredAndExited |
												NSTrackingActiveInActiveApp |
												NSTrackingActiveAlways;
		
		NSInteger index;
		for (index = 0; index < 8; index++)
		{
			// make tracking data (to be stored in NSTrackingArea's userInfo) so we can later determine which tracking area is focused on
			//
			NSDictionary* trackerData = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:index], kTrackerKey, nil];
			NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:[self rectForColorViewAtIndex:index]
																		options:trackingOptions
																		  owner:self
																	   userInfo:trackerData];
												
			[trackingAreas addObject:trackingArea];	// keep track of this tracking area for later disposal
			[self addTrackingArea: trackingArea];	// add the tracking area to the view/window
		}
	}
}

// -------------------------------------------------------------------------------
//	colorNameForIndex:
//
//	Returns the string corresponding to the tracking area.
// -------------------------------------------------------------------------------
-(NSString*)colorNameForIndex:(NSInteger)index
{
	NSString* name = @"";
	switch (index)
	{
		case kTrackingAreaGray:		// grey
			name = @"Gray";
			break;
			
		case kTrackingAreaPurple:	// purple
			name = @"Purple";
			break;
			
		case kTrackingAreaBlue:		// blue
			name = @"Blue";
			break;
			
		case kTrackingAreaGreen:	// green
			name = @"Green";
			break;
			
		case kTrackingAreaYellow:	// yellow
			name = @"Yellow";
			break;
			
		case kTrackingAreaOrange:	// orange
			name = @"Orange";
			break;
			
		case kTrackingAreaRed:		// red
			name = @"Red";
			break;
			
		case kTrackingAreaNone:		// none
			name = @"None";
			break;
	}
	return name;
}

#pragma mark -
#pragma mark Custom Drawing

// -------------------------------------------------------------------------------
//	drawRect:rect
//
//	Examine all the sub-view colored dots and color them with their appropriate colors.
// -------------------------------------------------------------------------------
-(void)drawRect:(NSRect)rect
{
	// see if we should be drawing any of the labels as already selected
	NSInteger currentlySelectedLabel = -1;
	if (delegate && [delegate conformsToProtocol:@protocol(CCTColorLabelMenuItemViewDelegate)])
	{
		currentlySelectedLabel = [delegate currentlySelectedLabel:self];
		if (currentlySelectedLabel == 0) {
			currentlySelectedLabel = -1;	// we don't want to display a selection around the "none" label option
		}
	}
	
	NSInteger index;
	for (index = 0; index < 8; index++)
	{
		NSRect colorSquareRect = [self rectForColorViewAtIndex:index];
				
		if (index == currentlySelectedLabel)
		{
			NSBezierPath *highlightPath = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(colorSquareRect, -1.5, -1.5)];
			[[NSColor colorWithCalibratedRed:0.76 green:0.78 blue:0.82 alpha:1.0] set];
			[highlightPath fill];
			
			[[NSColor colorWithCalibratedWhite:0.6 alpha:1.0] set];
			[highlightPath setLineWidth:1.0];
			[highlightPath stroke];
			
		}
		else if (index == selectedLabel)
		{
			if (trackEntered)
			{
				// if we are tracking inside any label, we want outline the color choice
				
				if (blink%2 == 0)
				{
					NSBezierPath *highlightPath = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(colorSquareRect, -1.5, -1.5)];
					[[NSColor colorWithCalibratedWhite:0.94 alpha:1.0] set];
					[highlightPath fill];
					
					[[NSColor colorWithCalibratedWhite:0.6 alpha:1.0] set];
					[highlightPath setLineWidth:1.0];
					[highlightPath stroke];
				}
				
				// draw the menu Label:
				NSMutableDictionary *fontAtts = [[NSMutableDictionary alloc] init];
				[fontAtts setObject:[NSFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
				[fontAtts setObject:[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] forKey:NSForegroundColorAttributeName];
				NSString *colorName = [NSString stringWithFormat:@"“%@”",[self colorNameForIndex:index]];
				[colorName drawAtPoint:NSMakePoint(70.0, 32.0) withAttributes:fontAtts];
			}
		}
		
		
		// draw the gradient dot
		NSGradient *gradient = [self gradientForLabel:index];
		NSRect dotRect = NSInsetRect(colorSquareRect, 2.0, 2.0);
		NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:dotRect];
		[gradient drawInBezierPath:circlePath angle:-90.0];
		
		
		// draw a highlight
		
		// top edge outline
		gradient = [[NSGradient alloc] initWithColorsAndLocations:
					[NSColor colorWithCalibratedWhite:1.0 alpha:0.18], 0.0,
					[NSColor colorWithCalibratedWhite:1.0 alpha:0.0], 0.6, nil];
		circlePath = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(dotRect, 1.0, 1.0)];
		[circlePath appendBezierPath:[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(dotRect.origin.x+1.0, dotRect.origin.y-2.0, dotRect.size.width-2.0, dotRect.size.height)]];
		[circlePath setWindingRule:NSEvenOddWindingRule];
		[gradient drawInBezierPath:circlePath angle:-90.0];
		
		// top center gloss
		gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.18] 
												 endingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0]];
		[gradient drawFromCenter:NSMakePoint(NSMidX(dotRect), NSMaxY(dotRect) - 2.0)
						  radius:0.0
						toCenter:NSMakePoint(NSMidX(dotRect), NSMaxY(dotRect) - 2.0)
						  radius:4.0
						 options:0];
		
		// draw a dark outline
		circlePath = [NSBezierPath bezierPathWithOvalInRect:dotRect];
		gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.12] 
												 endingColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.46]];
		[circlePath appendBezierPath:[NSBezierPath bezierPathWithOvalInRect:NSInsetRect(dotRect, 1.0, 1.0)]];
		[circlePath setWindingRule:NSEvenOddWindingRule];
		[gradient drawInBezierPath:circlePath angle:-90.0];
		
	}
	
	
	// draw the menu Label:
	NSMutableDictionary *fontAtts = [[NSMutableDictionary alloc] init];
	[fontAtts setObject: [NSFont menuFontOfSize:14.0] forKey: NSFontAttributeName];
	NSString *labelTitle = @"Label:";
	[labelTitle drawAtPoint:NSMakePoint(20.0, 32.0) withAttributes:fontAtts];
}


#pragma mark -
#pragma mark Mouse Handling

// -------------------------------------------------------------------------------
//	getTrackerIDFromDict:dict
//
//	Used in obtaining dictionary entry info from the 'userData', used by each
//	mouse event method.  It helps determine which tracking area is being tracked.
// -------------------------------------------------------------------------------
- (int)getTrackerIDFromDict:(NSDictionary*)dict
{
	id whichTracker = [dict objectForKey: kTrackerKey];
	return [whichTracker intValue];
}

// -------------------------------------------------------------------------------
//	mouseEntered:event
//
//	Because we installed NSTrackingArea to our NSImageView, this method will be called.
// -------------------------------------------------------------------------------
- (void)mouseEntered:(NSEvent*)event
{
	// which tracking area is being tracked?
	selectedLabel = [self getTrackerIDFromDict:[event userData]];
	trackEntered = YES;

	[self setNeedsDisplay:YES];	// force update the currently tracked label back to its original color
}

// -------------------------------------------------------------------------------
//	mouseExited:event
//
//	Because we installed NSTrackingArea to our NSImageView, this method will be called.
// -------------------------------------------------------------------------------
- (void)mouseExited:(NSEvent*)event
{
	// which tracking area is being tracked?
	selectedLabel = [self getTrackerIDFromDict:[event userData]];
	trackEntered = NO;

	[self setNeedsDisplay:YES];	// force update the currently tracked label to a lighter color
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

// -------------------------------------------------------------------------------
//	mouseDown:event
// -------------------------------------------------------------------------------
- (void)mouseUp:(NSEvent*)event
{
	NSPoint mousePoint = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
	
	// figure out which label color was clicked on at mouseUp time
	NSInteger index;
	for (index = 0; index < 8; index++)
	{
		NSRect labelRect = [self rectForColorViewAtIndex:index];
		if (NSPointInRect(mousePoint, labelRect))
		{
			// blink to indicate the user's selection
			blink = 1;
			[self setNeedsDisplay:YES];
			NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.065 target:self selector:@selector(blinkSelection:) userInfo:nil repeats:NO];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
		}
	}
}

- (void)blinkSelection:(NSTimer *)fired
{
	if (blink < 4)
	{
		blink++;
		[self setNeedsDisplay:YES];
		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.065 target:self selector:@selector(blinkSelection:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
	}
	else
	{
		blink = 0;
		// respond to the particular label selection
		[[[self enclosingMenuItem] target] performSelector:[[self enclosingMenuItem] action] withObject:self];
		
		// on mouse up, we want to dismiss the menu being tracked
		NSMenu* menu = [[self enclosingMenuItem] menu];
		[menu cancelTracking];
		
		// we are no longer tracking, reset the tracked label color (if any)
		selectedLabel = NSNotFound;
		[self setNeedsDisplay:YES];
		
	}
}


@end
