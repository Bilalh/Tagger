#import <Cocoa/Cocoa.h>

// This is a simple wrapper around the file system. Its main purpose is to cache children.
@interface FileSystemNode : NSObject {
@private
    NSURL *_url;
    NSArray *_children;
    BOOL _childrenDirty;
}

// The designated initializer
- (id)initWithURL:(NSURL *)url;

@property(readonly, assign) NSURL *URL;
@property(readonly, copy) NSString *displayName;
@property(readonly, retain) NSImage *icon;
@property(readonly, retain) NSArray *children;
@property(readonly) BOOL isDirectory;
@property(readonly, retain) NSColor *labelColor;

- (void)invalidateChildren;

@end
