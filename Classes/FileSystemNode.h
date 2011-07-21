
#import <Cocoa/Cocoa.h>
@class Tags;

/// This is a simple wrapper around the file system. Its main purpose is to cache children.
/// It also keeps the tags of audio file (only m4a at the moment)
/// The properties are cashed so it effient to repeatedly call them. 
@interface FileSystemNode : NSObject {
@private
    NSURL *_url;
    NSArray *_children;
    BOOL _childrenDirty;
	NSMutableArray* _parentNodes;
}

/// @name Initializing an FileSystemNode Object

/** The designated initializer
 
 If the file is music file (only m4a and mp3 at the moment) then the 
 tags would be found as well.
 
 @param url The filepath as url
 @return An instance of FileSystemNode 
 */
- (id)initWithURL:(NSURL *)url;


/// @name Finding Children and parent nodes 

/**  
 * Finds all the parent nodes
 * @return A array containing all the parent nodes 
 */
- (NSMutableArray*)parentNodes;

/// All the child nodes of this node 
@property(readonly, retain) NSArray  *children;

/// Recalucates all the children on call to children
- (void)invalidateChildren;

/// @name Finding metadata

/// The url of this node
@property(readonly, assign) NSURL    *URL;

/// The localised name of the node 
@property(readonly, copy)   NSString *displayName;

/// The node's icon
@property(readonly, retain) NSImage  *icon;

/// YES if a directory
@property(readonly)         BOOL      isDirectory;

/// The label colour of this node
@property(readonly, retain) NSColor  *labelColor;

/** The audio tags such as the title */
@property(readonly, assign) Tags      *tags;



@end
