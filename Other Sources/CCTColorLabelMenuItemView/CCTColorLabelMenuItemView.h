/*

File: TrackView.h

Abstract: The NSView that handles the label color tracking.
Dan Messing
 
Version: 1.0


*/

#import <Cocoa/Cocoa.h>


@protocol CCTColorLabelMenuItemViewDelegate;


@interface CCTColorLabelMenuItemView : NSView
{
	@private
	id<CCTColorLabelMenuItemViewDelegate> delegate;
	
	NSMutableArray* trackingAreas;
	
	NSInteger		selectedLabel;	// indicates the currently tracked label
	BOOL			trackEntered;	// indicates we are currently inside a label tracking area
	int				blink;
}

@property (nonatomic)   id<CCTColorLabelMenuItemViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger selectedLabel;

- (void)setupTrackingAreas;


@end



// define a protocol that a delegate of this menu item view needs to implement

@protocol CCTColorLabelMenuItemViewDelegate <NSObject>

// this method will allow the delegate to inform us if we should mark any label as already selected
- (NSInteger)currentlySelectedLabel:(CCTColorLabelMenuItemView *)colorLabelMenuItemView;

@end



