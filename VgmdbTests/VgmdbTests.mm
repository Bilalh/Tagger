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
                 withNotes:(BOOL)testNotes
                withTracks:(BOOL)testTracks
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
    
    @"genre",
    @"products", @"platforms",
    ];
    
    for (NSString *field in fields) {
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             @"%@ - %@",field, name);
        printf("\n\n");
    }
    
    if (testNotes){
        NSString *field = @"comment";
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             @"%@ - %@",field, name);
    }
    
//    STAssertEqualObjects(
//                         results,
//                         correct,
//                         @"Everything - %@",name);
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
    
    NSArray *genre = @[
        @"Game"
    ];
    
    NSArray *publishedFormat =@[
        @"Commercial"
    ];
    
    NSString *comment = @"All Composed / Arranged by Ken Nakagawa(Gust)\nAll Lyrics by Ken Nakagawa(Gust)\n\n* Opening Song \"Falling, The Star Light\"\nVocal / Chorus by Mineko Yamamoto(digitalis)\n\n* Ending Song \"Fushigi na Recipe\" [\"A Mysterious Recipe\"]\nVocal / Chorus by Nana Furuhara";
    
    NSDictionary *correct = @{
    @"album":album,
    @"url": url,
    @"catalog" : @"KDSD-10038~9",
    @"date" : @"Jun 24, 2009",
    @"year": @"2009",
    @"publishedFormat": publishedFormat,
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
    @"rating":  @"Rated 4.50 by 12 people",
    @"genre": genre,
    @"category": genre,
    @"comment":comment
    };
    
    [self testUsingTestData:correct
                  withNotes:YES
                 withTracks:NO];

}

- (void)testMutiMetadata
{
    NSString *name = @"mutiMetadata.html";
    NSURL *url = [self getUrlForName:name];

    NSDictionary *album =@{
        @"@english": @"Atelier Best",
        @"@kanji": @"アトリエ・ベスト",
        @"@romaji": @"Atelier Best"
    };

    NSArray *classification = @[
        @"Original Soundtrack",
        @"Vocal"
    ];

    NSArray *publisher =@[
        @{
            @"@english" :  @"Gust",
            @"@kanji":     @"株式会社ガスト",
            @"@romaji":    @"Gust"
        }
    ];

    NSArray *composer  =@[
        @{
            @"@english" : @"G.S.T. Gust Soundteam Atelier So-La",
        },
        @{
            @"@english" : @"Daisuke Achiwa",
            @"@kanji"   : @"阿知波大輔"
        },
        @{
            @"@english" : @"Toshiharu Yamanishi",
            @"@kanji"   : @"山西利治"
        },
        @{
            @"@english" : @"Akira Tsuchiya",
            @"@kanji"   : @"土屋暁"
        },
        @{
            @"@english" : @"Miyoko Kobayashi",
            @"@kanji"   : @"小林美代子"
        },
        @{
            @"@english" : @"Ken Nakagawa",
            @"@kanji"   : @"中河健"
        },

    ];

    NSArray *arranger  =@[
        @{
            @"@english" : @"Miyoko Kobayashi",
            @"@kanji"   : @"小林美代子"
        },
        @{
            @"@english" : @"Akira Tsuchiya",
            @"@kanji"   : @"土屋暁"
        },
        @{
            @"@english" : @"Thousand sketcheS",
        },
    ];

    NSArray *performer  =@[
        @{
            @"@english" : @"Yumi Higashino",
            @"@kanji"   : @"東野佑美"
        },
        @{
            @"@english" : @"Miki Nagasawa",
            @"@kanji"   : @"長沢美樹"
        },
        @{
            @"@english" : @"Miki Takahashi",
            @"@kanji"   : @"高橋美紀"
        },
        @{
            @"@english" : @"Shue Nagakura",
            @"@kanji"   : @"永倉秀恵"
        },
        @{
            @"@english" : @"Mami Horie",
            @"@kanji"   : @"堀江真美"
        },
    ];

    NSArray *products =@[
        @{
            @"@english":  @"Atelier Marie",
            @"@kanji":    @"マリーのアトリエ ～ザールブルグの錬金術士～",
            @"@romaji":   @"Marie no Atelier: Salburg no Renkinjutsushi"
        },
        @{
            @"@english":  @"Atelier Elie",
            @"@kanji":    @"エリーのアトリエ ～ザールブルグの錬金術士2～",
            @"@romaji":   @"Elie no Atelier: Salburg no Renkinjutsushi 2"
        },
        @{
            @"@english":  @"Atelier Lilie",
            @"@kanji":    @"リリーのアトリエ ～ザールブルグの錬金術士3～",
            @"@romaji":   @"Lilie no Atelier: Salburg no Renkinjutsushi 3"
        },
        @{
            @"@english":  @"Lilie no Atelier: Salburg no Renkinjutsushi 3 Plus",
        },
        @{
            @"@english":  @"Hermina and Culus",
            @"@kanji":    @"ヘルミーナとクルス ～リリーのアトリエ もう一つの物語～",
            @"@romaji":   @"Hermina to Culus: Lilie no Atelier Mou Hitotsu no Monogatari"
        },
        @{
            @"@english":  @"Atelier Judie",
            @"@kanji":    @"ユーディーのアトリエ ～グラムナートの錬金術士～",
            @"@romaji":   @"Judie no Atelier: Gramnad no Renkinjutsushi"
        },
        @{
            @"@english":  @"Atelier Viorate",
            @"@kanji":    @"ヴィオラートのアトリエ ～グラムナートの錬金術士2～",
            @"@romaji":   @"Viorate no Atelier: Gramnad no Renkinjutsushi 2"
        },
    ];

    NSArray *platforms = @[
        @"Sony PlayStation", @"Sony PlayStation 2"
    ];

    NSArray *genre = @[
        @"Game"
    ];

    NSArray *publishedFormat =@[
        @"Commercial", @"Preorder/Early Purchase Bonus"
    ];
    
    
    NSDictionary *correct = @{
    @"album":album,
    @"url": url,
    @"catalog" : @"GPR-VI001",
    @"date" : @"May 01, 2003",
    @"year": @"2003",
    @"publishedFormat": publishedFormat,
    @"price": @"Not for Sale",
    @"mediaFormat": @"CD",
    @"classification": classification,
    @"publisher": publisher,
    @"composer": composer,
    @"arranger": arranger,
    @"performer": performer,
    @"artist": composer,
    @"products": products,
    @"platforms":platforms,
    @"rating":  @"Rated 4.50 by 12 people",
    @"genre": genre,
    @"category": genre
    };


    [self testUsingTestData:correct
                  withNotes:NO
                 withTracks:NO];
}

- (void)testNoPlatforms_small
{
    NSString *name = @"noPlatforms_small.html";
    NSURL *url = [self getUrlForName:name];
    
    NSDictionary *album =@{
        @"@english": @"Nexus / ClariS",
        @"@kanji":   @"Nexus / ClariS",
        @"@romaji":  @"Nexus / ClariS"
    };
    
    NSArray *classification = @[@"Vocal"];
    
    NSArray *publisher =@[
    @{
        @"@english" :  @"SME Records",
        @"@kanji":     @"株式会社エスエムイーレコーズ",
        @"@romaji":    @"SME Records"
    },
    ];
    
    NSArray *composer  =@[
    @{
        @"@english" : @"kz",
    },
    @{
        @"@english" : @"小田桐ゆうき",
    },
    @{
        @"@english" : @"Hiroo Ooyagi",
        @"@kanji":     @"オオヤギヒロオ"
    },
    ];
    
    NSArray *arranger  =@[
    @{
        @"@english" : @"kz",
    },
    @{
        @"@english" : @"小田桐ゆうき",
    },
    @{
        @"@english" : @"Hiroo Ooyagi",
        @"@kanji":     @"オオヤギヒロオ"
    },
    ];
    
    NSArray *performer  =@[
    @{
        @"@english" : @"ClariS",
    },
    ];
    
    NSArray *products =@[
    @{
        @"@english":  @"Ore no Imouto ga Konnani Kawaii Wake ga nai",
    },
    ];
        
    NSArray *genre = @[
        @"Publication"
    ];
    
    NSArray *publishedFormat =@[
        @"Commercial"
    ];
    
    NSDictionary *correct = @{
    @"album":album,
    @"url": url,
    @"catalog" : @"SECL-1004~5",
    @"date" : @"Sep 14, 2011",
    @"year": @"2011",
    @"publishedFormat": publishedFormat,
    @"price": @"1575",
    @"mediaFormat": @"CD + DVD",
    @"classification": classification,
    @"publisher": publisher,
    @"composer": composer,
    @"arranger": arranger,
    @"performer": performer,
    @"artist": composer,
    @"products": products,
    @"rating":  @"Nobody has rated this album yet.",
    @"genre": genre,
    @"category": genre
    };
    
    [self testUsingTestData:correct
                  withNotes:NO
                 withTracks:NO];

}

//
//- (void)testMakeFiles
//{
//    NSString *name = @"noPlatforms_small.html";
//    NSString *url = @"http://vgmdb.net/album/30881";
//    NSString *path = [testFolder stringByAppendingPathComponent:name];
//    NSString *s=  [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
//                                           encoding:NSUTF8StringEncoding
//                                              error:nil];
//    [s writeToFile:path
//        atomically:YES
//          encoding:NSUTF8StringEncoding
//             error:nil];
//}

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
