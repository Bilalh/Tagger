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
#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);


#include <hcxselect.h>
NSString  *testFolder = @"/Users/bilalh/Projects/Tagger/Test Files/Albums/";

@interface VgmdbTests : SenTestCase

@end

Vgmdb *vgmdb;

@implementation VgmdbTests

- (void) testUsingTestData:(NSDictionary*)correct
{
 
    NSURL *url = [correct valueForKey:@"url"];
    
    NSString *name = [url lastPathComponent];
    
    NSDictionary *results =[vgmdb getAlbumData:url];
    
    NSArray *fields = @[
    @"album", @"url",@"catalog",
    @"date",@"publishedFormat",
    @"year",@"classification",
    @"publisher", @"composer",
    @"arranger", @"performer",
    @"artist",
    
    @"products", @"platforms",
    ];
    
    for (NSString *field in fields) {
//        NSLog(@"\n\n\n");
//        NSLog(@"%@ - %@",field, name);
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             @"%@ - %@",field, name);
        printf("\n\n");
    }
    STAssertEqualObjects(
                         results,
                         correct,
                         @"Everything - %@",name);
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
    NSLog(@"Testing: %@",name);
    NSURL *url = [self getUrlForName:name];
    
    NSDictionary *album =@{
        @"@english": @"Atelier Rorona Original Sound Track",
        @"@kanji": @"ロロナのアトリエ～アーランドの錬金術士～ オリジナルサウンドトラック",
        @"@romaji": @"Rorona no Atelier: Arland no Renkinjutsushi Original Sound Track"
    };
    
    NSArray *classification = @[@"Original Soundtrack"];
    
    NSArray *publisher =@[
        @{
            @"@english" : @"TEAM Entertainment",
            @"@kanji":     @"株式会社ティームエンタテインメント",
            @"@romaji":    @"TEAM Entertainment"
        },
        @{
            @"@english" : @"Sony Music Distribution",
            @"@kanji":     @"株式会社ソニー・ミュージックディストリビューション",
            @"@romaji":    @"Sony Music Distribution"
        }
    ];
    
    NSArray *composer  =@[
        @{
            @"@english" : @"Ken Nakagawa",
            @"@kanji"   : @"中河健"
        }
    ];

    NSArray *arranger  =@[
        @{
            @"@english" : @"Ken Nakagawa",
            @"@kanji"   : @"中河健"
        }
    ];

    NSArray *performer  =@[
        @{
            @"@english" : @"Mineko Yamamoto",
            @"@kanji"   : @"山本美禰子" // @"\u5c71\u672c\u7f8e\u79b0\u5b50"    // 
        },
        @{
            @"@english" : @"Nana Furuhara",
            @"@kanji"   : @"古原奈々"     //@"\u53e4\u539f\u5948\u3005"
        },
    ];
    
    NSArray *products =@[
        @{
            @"@english":  @"Atelier Rorona",
            @"@kanji":    @"ロロナのアトリエ　～アーランドの錬金術師～",
            @"@romaji":   @"Rorona no Atelier: Arland no Renkinjutsushi"
        },
    ];
    
    NSArray *platforms = @[
        @"Sony PlayStation 3"
    ];
    
    NSDictionary *correct = @{
    @"album":album,
    @"url": url,
    @"catalog" : @"KDSD-10038~9",
    @"date" : @"Jun 24, 2009",
    @"year": @"2009",
    @"publishedFormat": @"Commercial",
    @"price": @"3360",
    @"mediaFormat": @"2 CD",
    @"classification": classification,
    @"publisher": publisher,
    @"composer": composer,
    @"arranger": arranger,
    @"performer": performer,
    @"artist": composer,
    @"products": products,
    @"platforms":platforms,
    @"rating":  @"Rated 4.50 by 12 people"
    };
    
    
    [self testUsingTestData:correct];
    NSLog(@"done - %@\n\n", name);
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
