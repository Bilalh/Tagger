
#import <Cocoa/Cocoa.h>
@class Tags;

/// This is a simple wrapper around the file system. Its main purpose is to cache children.
/// It also keeps the tags of audio file (only m4a and mp3 at the moment)
/// The properties are cashed so it effient to repeatedly call them. 
@interface FileSystemNode : NSObject {
@private
    NSURL *_url;
    NSMutableArray *_children;
    BOOL _childrenDirty;
	NSMutableArray* _parentNodes;
	
	BOOL      hasBasicMetadata;
	BOOL      hasExtenedMetadata;
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
 * Finds all t/Users/bilalh/Programming/Projects/VGTagger/English.lproj/MainMenu.xibhe parent nodes
 * @return A array containing all the parent nodes 
 */
- (NSMutableArray*)parentNodes;

/// All the child nodes of this node 
@property(readonly) NSArray  *children;

/// Recalucates all the children on call to children
- (void)invalidateChildren;


-(NSError*)filenameFromFormatArray:(NSArray*)formatStrings;
-(NSError*)tagsWithFormatArrayFromFilename:(NSArray*)formatStrings;

- (void)sort:(NSString*)key
   ascending:(BOOL)ascending;

- (void)swapChildrenAtIndex:(NSInteger)index 
					   from:(NSInteger)remove
				removeFirst:(BOOL)removeFirst;

- (void)swapFirstAndLastName:(NSString*)key;


/// @name Finding metadata

/// The url of this node
@property(readonly) NSURL    *URL;

/// The localised name of the node 
@property(readonly, copy)   NSString *displayName;

/// The node's icon
@property(readonly) NSImage  *icon;

/// YES if a directory
@property(readonly)         BOOL      isDirectory;

/// The label colour of this node
@property(readonly) NSColor   *labelColor;
@property          NSNumber  *labelIndex;

/// The audio tags such as the title.
@property(readonly, strong) Tags      *tags;
/// YES if the file has basic metadata info.
@property(readonly)         BOOL      hasBasicMetadata;
/// YES if the file has extend metadata info.
@property(readonly)         BOOL      hasExtenedMetadata;

/// Size of the node
@property(readonly)         NSNumber  *size;

@end
