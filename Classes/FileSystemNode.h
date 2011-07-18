
#import <Cocoa/Cocoa.h>
@class Tags;

// This is a simple wrapper around the file system. Its main purpose is to cache children.
// It also keeps the tags of audio file (only m4a at the moment)
@interface FileSystemNode : NSObject {
@private
    NSURL *_url;
    NSArray *_children;
    BOOL _childrenDirty;
	NSMutableArray* _parentNodes;
}

// The designated initializer
- (id)initWithURL:(NSURL *)url;

@property(readonly, assign) NSURL    *URL;
@property(readonly, copy)   NSString *displayName;
@property(readonly, retain) NSImage  *icon;
@property(readonly, retain) NSArray  *children;
@property(readonly)         BOOL      isDirectory;
@property(readonly, retain) NSColor  *labelColor;

/** The audio tags such as title */
@property(readonly, assign) Tags      *tags;


 /**  
  * Finds all the parent nodes
  * @return A array containing all the parent nodes 
  */
- (NSMutableArray*)parentNodes;
- (void)invalidateChildren;

@end
