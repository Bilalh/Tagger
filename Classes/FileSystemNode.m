
#import "FileSystemNode.h"

@implementation FileSystemNode

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        _url = [url retain];
    }
    return self;
}

- (void)dealloc {
    // We have to release the underlying ivars associated with our properties
    [_url release];
    [_children release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", super.description, _url];
}

@synthesize URL = _url;
@dynamic displayName, children, isDirectory, icon, labelColor;

- (NSString *)displayName {
    id value = nil;
    NSError *error;
    if ([_url getResourceValue:&value forKey:NSURLLocalizedNameKey error:&error]) {
        return [value retain]; // hack work around the crash
    } else {
        return [error localizedDescription];
    }
}

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:[_url path]];
}

- (BOOL)isDirectory {
    id value = nil;
    [_url getResourceValue:&value forKey:NSURLIsDirectoryKey error:nil];
    return [value boolValue];
}

- (NSColor *)labelColor {
    id value = nil;
    [_url getResourceValue:&value forKey:NSURLLabelColorKey error:nil];
    return value;
}

// We are equal if we represent the same URL. This allows children to reuse the same instances.

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[FileSystemNode class]]) {
        FileSystemNode *other = (FileSystemNode *)object;
        return [other.URL isEqual:self.URL];
    } else {
        return NO;
    }
}

- (NSUInteger)hash {
    return self.URL.hash;
}

- (NSArray *)children {
    if (_children == nil || _childrenDirty) {
        // This logic keeps the same pointers around, if possible.
        NSMutableArray *newChildren = [NSMutableArray array];
        
        CFURLEnumeratorRef enumerator = CFURLEnumeratorCreateForDirectoryURL(NULL, (CFURLRef)_url, kCFURLEnumeratorSkipInvisibles, (CFArrayRef)[NSArray array]);
        NSURL *childURL = nil;
	CFURLEnumeratorResult enumeratorResult;
	do {
            enumeratorResult = CFURLEnumeratorGetNextURL(enumerator, (CFURLRef *)&childURL, NULL);
            if (enumeratorResult == kCFURLEnumeratorSuccess) {
                FileSystemNode *node = [[[FileSystemNode alloc] initWithURL:childURL] autorelease];
                if (_children != nil) {
                    NSInteger oldIndex = [_children indexOfObject:childURL];
                    if (oldIndex != NSNotFound) {
                        // Use the same pointer value, if possible
                        node = [_children objectAtIndex:oldIndex];
                    }
                }
                [newChildren addObject:node];
            } else if (enumeratorResult == kCFURLEnumeratorError) {
                // A possible enhancement would be to present error-based items to the user.
            }
	} while (enumeratorResult != kCFURLEnumeratorEnd);
        
        [_children release];
        _childrenDirty = NO;
        // Now sort them
        _children = [[newChildren sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSString *objName = [obj1 displayName];
            NSString *obj2Name = [obj2 displayName];
            NSComparisonResult result = [objName compare:obj2Name options:NSNumericSearch | NSCaseInsensitiveSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch range:NSMakeRange(0, [objName length]) locale:[NSLocale currentLocale]];
            return result;
        }] retain];
    }
    
    return _children;
}

- (void)invalidateChildren {
    _childrenDirty = YES;
    for (FileSystemNode *child in _children) {
        [child invalidateChildren];
    }
}

@end
