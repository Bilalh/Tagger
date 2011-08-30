//
//  GeneralPreferencesViewController.h
//  VGTagger
//
//  Created by Bilal Syed Hussain on 10/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
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
