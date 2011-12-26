//
//  QuickLookTableView.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 11/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import <Foundation/Foundation.h>

/// TableView when quicklook is started when space is pressed.
@interface QuickLookTableView : NSTableView {
@private
    
}

@end

@protocol QuickLookTableViewDelgate <NSObject>
@optional
// Return True if the event was handled
- (BOOL)tableView:(NSTableView *)tableView willKeyDown:(NSEvent *)event;

@end