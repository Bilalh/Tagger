//
//  Created by Vadim Shpakovski on 4/22/11.
//  Copyright 2011 Shpakovski. All rights reserved.
//

#import "MASPreferencesViewController.h"

@class MainController;

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>{
@private
	MainController *mainController;
	NSDictionary *tableColumns;
}

- (id)initWithMainController:(MainController*)mainController;
- (IBAction) open:(id)sender;


@property (assign) NSDictionary *tableColumns;

@end
