//
//  Created by Vadim Shpakovski on 4/22/11.
//  Copyright 2011 Shpakovski. All rights reserved.
//

#import "MASPreferencesViewController.h"

@class MainController;
@class ImageAndTextCell;

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>{
@private
	MainController *mainController;
	NSDictionary *tableColumns;
	IBOutlet ImageAndTextCell *imageCell;
}

- (id)initWithMainController:(MainController*)mainController;

- (IBAction) setStartUrlToCurrent:(id)sender;
- (void) setStartUrl:(NSURL*)url;
- (IBAction) open:(id)sender;


@property (assign) NSDictionary *tableColumns;

@end
