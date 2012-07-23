// Based on  BWHyperlinkButton from BWToolkit

#import "BWHyperlinkTitleButton.h"
#import "BWHyperlinkButtonCell.h"

@implementation BWHyperlinkTitleButton

-(void)awakeFromNib
{
	[self setTarget:self];
	[self setAction:@selector(openURLInBrowser:)];
}


- (void)openURLInBrowser:(id)sender
{
	if (![self respondsToSelector:@selector(ibDidAddToDesignableDocument:)])
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.title]];
}

- (void)resetCursorRects 
{
	[self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}


@end