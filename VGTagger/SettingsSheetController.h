//
//  SettingsSheetController.h
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SettingsSheetController : NSWindowController {
@private
	IBOutlet NSWindow    *window;
}

-(IBAction)cancelSheet:sender;
-(IBAction)confirmSheet:sender;
@end
