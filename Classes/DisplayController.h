//
//  SettingsSheetController.h
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisplayController : NSWindowController {
@private
	IBOutlet NSWindow    *window;
	IBOutlet NSTextField *album;
	id vgmdb; // macruby Vgmdb class
	NSDictionary *albumDetails;
}

- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;

- (void)setAlbumUrl:(NSString *)url;
- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject;




@end
