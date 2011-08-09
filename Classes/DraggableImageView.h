//
//  DraggableImageView.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DraggableImageView : NSImageView {
@private
	NSEvent* downEvent;
}

@property (assign) NSEvent* downEvent;

@end
