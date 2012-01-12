
#import "FileSystemNode.h"
#import "Tags.h"
#import "MP4Tags.h"
#import "MPEGTags.h"
#import "NSNumber+compare.h"

#import "RegexKitLite.h"
#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_INFO);

static const NSDictionary *tokenDict;
static const NSSet *tokensNumberSet;


@interface FileSystemNode()
- (BOOL) isaDirectory:(NSURL*)url;
@end

@implementation FileSystemNode
@synthesize URL = _url, tags, hasBasicMetadata, hasExtenedMetadata, size;
@dynamic displayName, children, isDirectory, icon, labelColor, labelIndex;

#pragma mark -
#pragma mark Init

+ (void) initialize
{
	const NSString *str = @"(.*)", *num = @"(\\d+)";
	tokenDict = [[NSDictionary  alloc] initWithObjectsAndKeys:
							   str, @"title",
							   str, @"album",  
							   str, @"artist", 
							   str, @"composer", 
							   str, @"year",
							   str, @"genre",  
							   str, @"albumArtist",
							   num, @"track",  
							   num, @"disc",   
							   nil];
	
	tokensNumberSet = [[NSSet alloc ] initWithObjects: 
				 @"album",  @"year", @"track",  @"disc", nil];
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        _url = [url retain];
		if (! [self isDirectory] ){
			NSString *path = [url path];
			
			if ([path hasSuffix:@"m4a"]){
				tags = [[MP4Tags alloc] initWithFilename:path];
				hasBasicMetadata   = true;
				hasExtenedMetadata = true;
			}else if ([path hasSuffix:@"mp3"]){
				tags = [[MPEGTags alloc] initWithFilename:path];
				hasBasicMetadata   = true;
				hasExtenedMetadata = true;
			}else{
				tags = nil;	
				hasBasicMetadata   = false;
				hasExtenedMetadata = false;
			}
		}
    }
    return self;
}

- (void)dealloc {
    // We have to release the underlying ivars associated with our properties
    [_url release];
    [_children release];
    [super dealloc];
}

#pragma mark -
#pragma mark Display

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", super.description, [[_url path] lastPathComponent]];
}

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

- (NSColor *)labelColor {
    id value = nil;
    [_url getResourceValue:&value forKey:NSURLLabelColorKey error:nil];
    return value;
}

- (void) setLabelIndex:(NSNumber *)labelIndex
{
	[_url setResourceValue:labelIndex forKey:NSURLLabelNumberKey error:nil];
}

- (NSNumber*) labelIndex
{
	id value = nil;
    [_url getResourceValue:&value forKey:NSURLLabelNumberKey error:nil];
    return value;
}

#pragma mark -
#pragma mark Metadata

- (BOOL)isDirectory {
	return [self isaDirectory:_url];
}

- (BOOL)isaDirectory:(NSURL*)url {
    id value = nil;
    [url getResourceValue:&value forKey:NSURLIsDirectoryKey error:nil];
    return [value boolValue];
}


- (NSNumber*)size{
    id value = nil;
    [_url getResourceValue:&value forKey:NSURLFileAllocatedSizeKey error:nil];
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

#pragma mark -
#pragma mark Finding Parent and child nodes

- (NSMutableArray*)parentNodes
{

	// FIXME parentNode does not cashe right
//	if (_parentNodes){
//		NSLog(@"already have parentNodes");
//		return _parentNodes;
//	}
	NSString *path = [[_url path] stringByStandardizingPath];
	_parentNodes = [[NSMutableArray alloc] init];
	
	[_parentNodes addObject:[[[FileSystemNode alloc] initWithURL:
							 [[NSURL alloc]initFileURLWithPath:path ]] 
							autorelease]];
	while (![path isEqualToString:@"/"] ){
		path = [path stringByDeletingLastPathComponent];
		if ([path isEqualToString:@""]) break;
		[_parentNodes addObject:[[[FileSystemNode alloc] initWithURL:
								 [[NSURL alloc]initFileURLWithPath:path ]] 
								autorelease]];
	}

	return _parentNodes;	
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
				NSString *extension = [[node.URL path] pathExtension];
				//TODO make user passable block
				if ([extension isEqualToString:@"mp3"]  || 
					[extension isEqualToString:@"m4a"]  || 
//					[extension isEqualToString:@"flac"] || 
//					[extension isEqualToString:@"ogg"]  || 
//					[extension isEqualToString:@"wma"]  || 
					[self isaDirectory:node.URL ] ){
					[newChildren addObject:node];
				}
				
            } else if (enumeratorResult == kCFURLEnumeratorError) {
                // A possible enhancement would be to present error-based items to the user.
            }
		} while (enumeratorResult != kCFURLEnumeratorEnd);
        
        [_children release];
        _childrenDirty = NO;
        // Now sort them
        [newChildren sortUsingComparator:^(id obj1, id obj2) {
            NSString *objName = [obj1 displayName];
            NSString *obj2Name = [obj2 displayName];
            NSComparisonResult result = [objName compare:obj2Name options:NSNumericSearch | NSCaseInsensitiveSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch range:NSMakeRange(0, [objName length]) locale:[NSLocale currentLocale]];
            return result;
        }];
		_children = [newChildren retain];
    }
    
    return _children;
}


- (void)invalidateChildren {
    _childrenDirty = YES;
    for (FileSystemNode *child in _children) {
        [child invalidateChildren];
    }
}


- (NSError*) filenameFromFormatArray:(NSArray*)formatStrings
{
	NSString *newName = [tags filenameFromFormatArray:formatStrings];
	newName = [newName stringByReplacingOccurrencesOfString:@"/" withString:@":"];
	
	DDLogInfo(@"newName:%@", newName);
	if (!newName || [newName isEqualToString:@""]){
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:@"New Name Empty" forKey:NSLocalizedDescriptionKey];
		return [NSError errorWithDomain:@"filenameFromFormatArray" code:100 userInfo:errorDetail];
	}
	
	NSString *path    = [self.URL path];
	NSString *ext     = [path pathExtension];
	
	NSString *newPath = [[[path stringByDeletingLastPathComponent] 
	 stringByAppendingPathComponent:newName] stringByAppendingPathExtension:ext];
	DDLogVerbose(@"path:%@\n ext:%@\n newPath:%@ \n", path, ext, newPath);
	
	if ([newPath isEqualToString:path]){
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:@"Moving to the same location" forKey:NSLocalizedDescriptionKey];
		return [NSError errorWithDomain:@"filenameFromFormatArray" code:101 userInfo:errorDetail];
	}
	
	NSError *err =nil;
	[[NSFileManager defaultManager] moveItemAtPath:path 
											toPath:newPath
											 error:&err];
	
	return err;
}


-(NSError*) tagsWithFormatArrayFromFilename:(NSArray*)formatStrings
{
	NSError *err = nil;
	if (!tags){
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:@"No Tags" forKey:NSLocalizedDescriptionKey];
		return [NSError errorWithDomain:@"tagsWithFormatArrayFromFilename" code:100 userInfo:errorDetail];
	}
	
	NSString *filename = [[self.URL path] stringByDeletingPathExtension];

	NSMutableString *regex = [[NSMutableString alloc] init];
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	
	for (NSString *format in formatStrings) {
		NSString *patten = [tokenDict objectForKey:format];
		if (patten){
			[regex appendString: patten];
			[keys addObject:format];
		}else{
			[regex appendString: format];
		}
	}
	
	NSArray *captures =  [filename captureComponentsMatchedByRegex:regex];
	DDLogInfo(@"captures: %@", captures);
	
	if ([captures count] -1 != [keys count] ){
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:[@"Matching failed for Regex: " stringByAppendingString:regex] forKey:NSLocalizedDescriptionKey];
		return [NSError errorWithDomain:@"tagsWithFormatArrayFromFilename" code:100 userInfo:errorDetail];
	}
	
	int i;
	for (i =1; i< [captures count]; ++i) {
		DDLogInfo(@"%@ %@",[keys objectAtIndex:i-1], [captures objectAtIndex:i] );
		id value = [captures objectAtIndex:i];
		if ([tokensNumberSet containsObject:[keys objectAtIndex:i-1]]){
			value= [NSNumber numberWithInt:[value intValue]];
		}
		[tags setValue: value forKey:[keys objectAtIndex:i-1]];
	}
	return err;
}


- (void) sort:(NSString*)key
	ascending:(BOOL)ascending
{
	NSArray *children = self.children;
	[children count];
	
	short mult = ascending ? 1 : -1;
	if ([key isEqualToString:@"filename"]){
		[_children sortWithOptions:NSSortStable usingComparator:
		 ^NSComparisonResult(id obj1, id obj2) {
			 const FileSystemNode *a = obj1, *b = obj2;
			 return  mult *[a.displayName localizedStandardCompare:b.displayName ];
		 }];
		
	}else if ([key isEqualToString:@"size"]){
		[_children sortWithOptions:NSSortStable usingComparator:
		 ^NSComparisonResult(id obj1, id obj2) {
			 const FileSystemNode *a = obj1, *b = obj2;
			 return  mult *[[a valueForKey:key] localizedStandardCompare:[b valueForKey:key ]];
		 }];
		
	}else{
		key = [key stringByReplacingOccurrencesOfString:@"Pair" withString:@""];
		[_children sortWithOptions:NSSortStable usingComparator:
		 ^NSComparisonResult(id obj1, id obj2) {
			 const FileSystemNode *a = obj1, *b = obj2;
			 return  mult *[[a.tags valueForKey:key] localizedStandardCompare:[b.tags valueForKey:key ]];
		 }];
	}		
}

- (void)swapChildrenAtIndex:(NSInteger)index 
					   from:(NSInteger)remove
				removeFirst:(BOOL)removeFirst
{
	NSArray *children = self.children;
	[children count];
	if (removeFirst){
		const id temp = [_children objectAtIndex:remove];
		[_children removeObjectAtIndex:remove];
		[_children insertObject:temp atIndex:index];
	}else{
		[_children insertObject:[_children objectAtIndex:remove] atIndex:index];
		[_children removeObjectAtIndex:remove];
	}
}



- (void)swapFirstAndLastName:(NSString*)key
{
	if (!tags) return;
	

	NSString *val = [tags valueForKey:key];
	DDLogInfo(@"key %@  value %@  --  title %@", key, val, tags.title);
	if (!val || [val length] == 0) return;
	
	
	NSArray *arr = [val componentsSeparatedByRegex:@"[&,] ?"]; 
	
	NSMutableArray  *dst = [[NSMutableArray alloc] init];
	
	for (NSString *s in arr) {
		NSArray *cap = [s captureComponentsMatchedByRegex:@"^(\\w+) (\\w+)$"];
		DDLogVerbose(@"Captures %@", cap);
		if ([cap count] != 3){
			[dst addObject:s];
		}else{
			[dst addObject:[[NSString alloc] 
							initWithFormat:@"%@ %@",
							[cap objectAtIndex:2], [cap objectAtIndex:1]]];
		}
	}
	
	DDLogInfo(@"Results key %@ value %@ title %@ -- %@", dst);
	
	if ([dst count] == 2){
	 	[tags setValue:[[NSString alloc]  initWithFormat:@"%@ %@",
						[dst objectAtIndex:0], [dst objectAtIndex:1]] 
				forKey:key];
	}else if ([dst count] > 2){
		[tags setValue:[dst componentsJoinedByString:@", "] forKey:key];
	}else{
		[tags setValue:[dst objectAtIndex:0] forKey:key];
	}
	
}



@end
