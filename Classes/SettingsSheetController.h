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
	IBOutlet NSTextField *album;
	id vgmdb; // macruby Vgmdb class
	NSDictionary *albumDetails;
}

-(IBAction)cancelSheet:sender;
-(IBAction)confirmSheet:sender;

-(id)initWithWindowNibNameAndVgmdb:(NSString*)nibName
							 vgmdb:(id)vgmdbObject;
-(void)reset;
-(void)setAlbum:(NSString *)url;



@end
