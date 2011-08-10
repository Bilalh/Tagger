//
//  DraggableImageView.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 09/08/2011.
//  Copyright 2011  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHDraggableImageView.h"

@class FileSystemNode;

/// NSImageView where the image can be dragged to any 
/// other image source as a file
@interface DraggableImageView : BHDraggableImageView  {
@private

}

@property (assign) FileSystemNode *current;


@end
