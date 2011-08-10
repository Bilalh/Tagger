//
//  DraggableImageView.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>

/// NSImageView where the image can be dragged to any 
/// other image source as a file
@interface BHDraggableImageView : NSImageView {
@private
	NSEvent* downEvent;
}

@property (assign) NSEvent* downEvent;

- (NSString*) makeFilename;

@end
