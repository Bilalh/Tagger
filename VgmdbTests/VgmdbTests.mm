//
//  VgmdbTests.m
//  VgmdbTests
//
//  Created by Bilal Syed Hussain on 28/07/2012.
//

#import <Foundation/Foundation.h>
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

- (void) testUsingTestData:(NSDictionary*)correct
{
 
    NSURL *url = [correct valueForKey:@"url"];
    
    NSDictionary *results =[vgmdb getAlbumData:url];
    
    NSArray *fields = @[@"catalog", @"album", @"url"];
    
    for (NSString *field in fields) {
                NSLog(@"\n\n\n");
        NSLog(@"%@",field);
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             field);
    }
    
    STAssertEqualObjects(
                         results,
                         correct,
                         @"Everything");
}

-(NSURL*)getUrlForName:(NSString*)name
{
    NSString *_url = [testFolder stringByAppendingPathComponent:name];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:_url];
    return url;
}

- (void)testMutiDisk
{
    NSString *name = @"muti-disk.html";
    NSLog(@"%@",name);
    NSURL *url = [self getUrlForName:name];
    
    NSDictionary *album =@{
        @"@english": @"Atelier Rorona Original Sound Track",
        @"@kanji": @"ロロナのアトリエ～アーランドの錬金術士～ オリジナルサウンドトラック",
        @"@romaji": @"Rorona no Atelier: Arland no Renkinjutsushi Original Sound Track"
    };
    
    NSDictionary *correct = @{
        @"catalog" : @"KDSD-10038~9",
        @"album":album,
        @"url": url
    };
    
    
    [self testUsingTestData:correct];
    NSLog(@"done\n\n");
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
