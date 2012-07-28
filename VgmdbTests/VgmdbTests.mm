//
//  VgmdbTests.m
//  VgmdbTests
//
//  Created by Bilal Syed Hussain on 28/07/2012.
//

#import <Cocoa/Cocoa.h>
#import <SenTestingKit/SenTestingKit.h>

#import <vgmdb/Vgmdb.h>
#import <vgmdb/Vgmdb+private.h>
#import <Logging/Logging.h>

#include <hcxselect.h>

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);


NSString  *testFolder = @"/Users/bilalh/Projects/Tagger/Test Files/Albums/";

@interface VgmdbTests : SenTestCase

@end

Vgmdb *vgmdb;

@implementation VgmdbTests


- (void)testmutiDisk
{
    NSString *_url = [testFolder stringByAppendingPathComponent:@"muti-disk.html"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:_url];

    NSLog(@"%@", vgmdb);
    NSDictionary *results =[vgmdb getAlbumData:url];
    
    NSDictionary *correct = @{
        @"catalog" : @"KDSD-10038~9",
        @"url": @"file://localhost/Users/bilalh/Projects/Tagger/Test%20Files/Albums/muti-disk.html"
    };

    
    [correct valueForKey:@"catalog"];

    NSArray *fields = @[@"catalog", @"album", @"url"];
    
    for (NSString *field in fields) {
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             field);
        NSLog(@"\n\n\n");
    }

    STAssertEqualObjects(
                         results,
                         correct,
                         @"Everything");
}


#pragma mark -
#pragma mark Setup

- (void)setUp
{
    [super setUp];
    vgmdb = [Vgmdb new];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

@end
