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
#import <Categories/NSString+Regex.h>

#import <Logging/Logging.h>
#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);

#include <iconv.h>
#include <hcxselect.h>
static NSString  *testFolder = @"/Users/bilalh/Projects/Tagger/Test Files/Albums/";

@interface VgmdbTests : SenTestCase

@end

static Vgmdb *vgmdb;

@implementation VgmdbTests

#pragma mark -
#pragma mark Search Results

- (void) testSearch
{
    NSString *name   = @"searchResults.html";
    NSURL *url = [self getUrlForName:name];

    NSArray *results = [vgmdb _searchResults:url];
    
    NSArray *correct =@[
    @{
        @"album" : @{
            @"@english" : @"- Twilight Hour - Atelier Ayesha -Alchemist of the Ground of Dusk- Vocal Album",
            @"@kanji"   : @"- Twilight Hour -\u30a2\u30fc\u30b7\u30e3\u306e\u30a2\u30c8\u30ea\u30a8\uff5e\u9ec4\u660f\u306e\u5927\u5730\u306e\u932c\u91d1\u8853\u58eb\uff5e\u30dc\u30fc\u30ab\u30eb\u30a2\u30eb\u30d0\u30e0",
            @"@romaji"  : @"- Twilight Hour - Ayesha no Atelier: Tasogare no Daichi no Renkinjutsushi Vocal Album",
        },
        @"catalog"   : @"GUSTCD-10010",
        @"released"  : @"Jun 27, 2012",
        @"url"       : @"http://vgmdb.net/album/32234",
    },
        @{
        @"album" : @{
            @"@english" : @"Atelier Ayesha Recollection Archives",
            @"@kanji"   : @"\u30a2\u30fc\u30b7\u30e3\u306e\u30a2\u30c8\u30ea\u30a8 \u30ea\u30b3\u30ec\u30af\u30b7\u30e7\u30f3\u30a2\u30fc\u30ab\u30a4\u30d6\u30b9",
            @"@romaji"  : @"Atelier Ayesha Recollection Archives",
        },
        @"catalog"   : @"N/A",
        @"released"  : @"Jun 27, 2012",
        @"url"       : @"http://vgmdb.net/album/34019",
    },
        @{
        @"album" : @{
            @"@english" : @"Atelier Ayesha ~Alchemist of the Ground of Dusk~ Original Soundtrack",
            @"@kanji"   : @"\u30a2\u30fc\u30b7\u30e3\u306e\u30a2\u30c8\u30ea\u30a8\uff5e\u9ec4\u660f\u306e\u5927\u5730\u306e\u932c\u91d1\u8853\u58eb\uff5e \u30aa\u30ea\u30b8\u30ca\u30eb\u30b5\u30a6\u30f3\u30c9\u30c8\u30e9\u30c3\u30af",
            @"@romaji"  : @"Ayesha no Atelier: Tasogare no Daichi no Renkinjutsushi Original Soundtrack",
        },
        @"catalog"   : @"GUSTCD-10007~9",
        @"released"  : @"Jun 27, 2012",
        @"url"       : @"http://vgmdb.net/album/32230",
    }
    ];
    
    for (NSUInteger i; i < [correct count]; i++) {
        
        NSDictionary *cor = correct[i];
        NSDictionary *res = results[i];
     
        for (NSString* key in cor) {
            STAssertEqualObjects(
                                 [res valueForKey:key],
                                 [cor valueForKey:key],
                                 @"%@ - %@",key, name);
        }
        
        STAssertEqualObjects(cor,res, @"%@",name);
    }
    
}

- (void) testSingleResult
{
    NSString *name   = @"oneResult.html";
    NSURL *url = [self getUrlForName:name];
    
    id _results = [vgmdb _searchResults:url];
    NSDictionary *results = _results;
    
    NSDictionary * album =     @{
        @"@english" : @"Lunar 2: Eternal Blue Complete Music Soundtrack",
        @"@kanji": @"Lunar 2: Eternal Blue Complete Music Soundtrack",
        @"@romaji": @"Lunar 2: Eternal Blue Complete Music Soundtrack",
    };
 
    NSDictionary *correct =@{
        @"album": album
    };
    
    NSString *field = @"album";
    STAssertEqualObjects(
                         [results valueForKey:field],
                         [correct valueForKey:field],
                         @"%@ - %@",field, name);
    
}

#pragma mark -
#pragma mark Album Data

- (void) testUsingTestData:(NSDictionary*)correct
              withMetadata:(BOOL)testmetadata
                 withStats:(BOOL)testStats
                 withNotes:(BOOL)testNotes
                withTracks:(BOOL)testTracks
{
 
    NSURL *url = [correct valueForKey:@"url"];
    NSString *name = [url lastPathComponent];
    NSDictionary *results =[vgmdb getAlbumData:url];
    
    if (testmetadata){
        NSArray *fields = @[
        @"album", @"url",@"catalog",
        @"date",@"publishedFormat",
        @"year",@"classification",
        @"publisher", @"composer",
        @"arranger", @"performer",
        @"artist"
        ];
        

        
        for (NSString *field in fields) {
            STAssertEqualObjects(
                                 [results valueForKey:field],
                                 [correct valueForKey:field],
                                 @"%@ - %@",field, name);
        }
    }
    
    if (testStats){
        NSArray *stats = @[
        @"genre",
        @"products", @"platforms",
//        @"rating"
        ];
        for (NSString *field in stats) {
            STAssertEqualObjects(
                                 [results valueForKey:field],
                                 [correct valueForKey:field],
                                 @"%@ - %@",field, name);
        }
    }
    
    if (testNotes){
        NSString *field = @"comment";
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             @"%@ - %@",field, name);
    }
    
    if (testTracks){
        NSString *field = @"tracks";
        STAssertEqualObjects(
                             [results valueForKey:field],
                             [correct valueForKey:field],
                             @"%@ - %@",field, name);
    }
    
//    STAssertEqualObjects(
//                         results,
//                         correct,
//                         @"Everything - %@",name);
    printf("\n\n");
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
               withMetadata:YES
                  withStats:YES
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
    @"rating":  @"Rated 4.13 by 4 people",
    @"genre": genre,
    @"category": genre
    };


    [self testUsingTestData:correct
               withMetadata:YES
                  withStats:YES     
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
               withMetadata:YES
                  withStats:YES
                  withNotes:NO
                 withTracks:NO];

}
 
NSDictionary *tracksForTesting =
@{
    @"1-1" :     @{
         @"track": @(1),
         @"disc" : @(1),
         @"length" : @"4:18",
         @"title" :        @{
             @"@english" : @"Cross Heart",
             @"@kanji" : @"\u30af\u30ed\u30b9*\u30cf\u30fc\u30c8",
         },
     },
     @"1-2" :    @{
         @"track": @(2),
         @"disc" : @(1),
         @"length" : @"5:14",
         @"title" :        @{
             @"@english" : @"Mizutama",
             @"@kanji" : @"\u6c34\u7389",
         },
     },
     @"1-3" :    @{
         @"track": @(3),
         @"disc" : @(1),
         @"length" : @"4:18",
         @"title" :        @{
             @"@english" : @"Cross Heart (instrumental)",
             @"@kanji" : @"\u30af\u30ed\u30b9*\u30cf\u30fc\u30c8<instrumental>",
         },
     },
     @"1-4" :    @{
         @"track": @(4),
         @"disc" : @(1),
         @"length" : @"5:11",
         @"title" :        @{
             @"@english" : @"Mizutama (instrumental)",
             @"@kanji" : @"\u6c34\u7389<instrumental>",
         },
     },
}; 
 
- (void)testTracks
{
    NSString *name = @"singleDisk.html";
    NSURL *url = [self getUrlForName:name];


    
    NSDictionary *correct = @{
        @"url": url,
        @"tracks":tracksForTesting
    };
    
    [self testUsingTestData:correct
               withMetadata:NO
                  withStats:NO
                  withNotes:NO
                 withTracks:YES];

}

- (void)testDifferent
{
    NSString *name = @"different.html";
    NSURL *url = [self getUrlForName:name];
    
    NSDictionary *correct =
    @{
        @"album" :@{
            @"@english" : @"- Twilight Hour - Atelier Ayesha -Alchemist of the Ground of Dusk- Vocal Album",
            @"@kanji" : @"- Twilight Hour -\u30a2\u30fc\u30b7\u30e3\u306e\u30a2\u30c8\u30ea\u30a8\uff5e\u9ec4\u660f\u306e\u5927\u5730\u306e\u932c\u91d1\u8853\u58eb\uff5e\u30dc\u30fc\u30ab\u30eb\u30a2\u30eb\u30d0\u30e0",
            @"@romaji" : @"- Twilight Hour - Ayesha no Atelier: Tasogare no Daichi no Renkinjutsushi Vocal Album",
        },
        @"arranger" :@[
            @{
                @"@english" : @"Kazuki Yanagawa",
                @"@kanji" : @"\u67f3\u5ddd\u548c\u6a39",
            },
            @{
                @"@english" : @"Rurutia",
            },
            @{
                @"@english" : @"Daisuke Achiwa",
                @"@kanji" : @"\u963f\u77e5\u6ce2\u5927\u8f14",
            },
            @{
                @"@english" : @"Chirinuruwowaka",
            }
        ],
        @"artist" :@[
            @{
                @"@english" : @"Kazuki Yanagawa",
                @"@kanji" : @"\u67f3\u5ddd\u548c\u6a39",
            },
            @{
                @"@english" : @"Rurutia",
            },
            @{
                @"@english" : @"Daisuke Achiwa",
                @"@kanji" : @"\u963f\u77e5\u6ce2\u5927\u8f14",
            },
            @{
                @"@english" : @"Yu Shimoda",
                @"@kanji" : @"\u4e0b\u7530\u7950",
            },
            @{
                @"@english" : @"Yumi Nakashima",
            }
        ],
        @"catalog" :@"GUSTCD-10010",
        @"category" :@[
            @"Game"
        ],
        @"classification" :@[
            @"Vocal"
        ],
        @"composer" :@[
            @{
                @"@english" : @"Kazuki Yanagawa",
                @"@kanji" : @"\u67f3\u5ddd\u548c\u6a39",
            },
            @{
                @"@english" : @"Rurutia",
            },
            @{
                @"@english" : @"Daisuke Achiwa",
                @"@kanji" : @"\u963f\u77e5\u6ce2\u5927\u8f14",
            },
            @{
                @"@english" : @"Yu Shimoda",
                @"@kanji" : @"\u4e0b\u7530\u7950",
            },
            @{
                @"@english" : @"Yumi Nakashima",
            }
        ],
        @"date" :@"Jun 27, 2012",
        @"genre" :@[
            @"Game",
        ],
        @"mediaFormat" :@"CD",
        @"performer" :@[
            @{
                @"@english" : @"Mutsumi Nomiyama",
                @"@kanji" : @"\u91ce\u898b\u5c71\u7766\u672a",
            },
            @{
                @"@english" : @"Rurutia",
            },
            @{
                @"@english" : @"yanaginagi",
                @"@kanji" : @"\u3084\u306a\u304e\u306a\u304e",
            },
            @{
                @"@english" : @"Saya",
            },
            @{
                @"@english" : @"Tae",
            },
            @{
                @"@english" : @"Haruka Shimotsuki",
                @"@kanji" : @"\u971c\u6708\u306f\u308b\u304b",
            },
            @{
                @"@english" : @"Chirinuruwowaka",
            },
            @{
                @"@english" : @"Annabel",
            }
        ],
        @"platforms" :@[
            @"Sony PlayStation 3"
        ],
        @"price" :@(2415),
        @"products" :@[
                @{
                @"@english" : @"Atelier Ayesha",
                @"@kanji" : @"\u30a2\u30fc\u30b7\u30e3\u306e\u30a2\u30c8\u30ea\u30a8 \uff5e\u9ec4\u660f\u306e\u5927\u5730\u306e\u932c\u91d1\u8853\u58eb\uff5e",
                @"@romaji" : @"Ayesha no Atelier: Tasogare no Daichi no Renkinjutsushi",
            }
        ],
        @"publishedFormat" :@[
            @"Commercial"
        ],
        @"publisher" :@[
                @{
                @"@english" : @"Gust",
                @"@kanji" : @"\u682a\u5f0f\u4f1a\u793e\u30ac\u30b9\u30c8",
                @"@romaji" : @"Gust",
            }
        ],
        @"rating" :@"Rated 4.75 by 2 people",
        @"totalDiscs" :@(1),
        @"totalTracks" :@(0),
        @"tracks" :@{
            @"1-1" :     @{
                @"disc" :@(1),
                @"length" :@"3:27",
                @"title" :        @{
                    @"@english" : @"Flower Sign",
                    @"@kanji" : @"\u82b1\u6a19",
                    @"@romaji" : @"Hanashirube",
                },
                @"track" :@(1),
            },
            @"1-2" :     @{
                @"disc" :@(1),
                @"length" :@"5:45",
                @"title" :        @{
                    @"@english" : @"Mystic Pendulum",
                    @"@kanji" : @"Mystic Pendulum",
                    @"@romaji" : @"Mystic Pendulum",
                },
                @"track" :@(2),
            },
            @"1-3" :     @{
                @"disc" :@(1),
                @"length" :@"3:38",
                @"title" :        @{
                    @"@english" : @"Thorns",
                    @"@kanji" : @"\u3044\u3070\u3089",
                    @"@romaji" : @"Ibara",
                },
                @"track" :@(3),
            },
            @"1-4" :     @{
                @"disc" :@(1),
                @"length" :@"4:42",
                @"title" :        @{
                    @"@english" : @"Stargazer",
                    @"@kanji" : @"Stargazer",
                    @"@romaji" : @"Stargazer",
                },
                @"track" :@(4),
            },
            @"1-5" :     @{
                @"disc" :@(1),
                @"length" :@"4:20",
                @"title" :        @{
                    @"@english" : @"Twilight",
                    @"@kanji" : @"\u9ec4\u660f",
                    @"@romaji" : @"Tasogare",
                },
                @"track" :@(5),
            },
            @"1-6" :     @{
                @"disc" :@(1),
                @"length" :@"5:50",
                @"title" :        @{
                    @"@english" : @"MARIA",
                    @"@kanji" : @"MARIA",
                    @"@romaji" : @"MARIA",
                },
                @"track" :@(6),
            },
            @"1-7" :     @{
                @"disc" :@(1),
                @"length" :@"5:07",
                @"title" :        @{
                    @"@english" : @"Stars at Dusk",
                    @"@kanji" : @"\u5bb5\u306e\u661f",
                    @"@romaji" : @"Yoi no Hoshi",
                },
                @"track" :@(7),
            },
            @"1-8" :     @{
                @"disc" :@(1),
                @"length" :@"4:51",
                @"title" :        @{
                    @"@english" : @"Dream-Weaving House",
                    @"@kanji" : @"\u5922\u3092\u7e54\u308b\u5bb6",
                    @"@romaji" : @"Yume wo Oru Ie",
                },
                @"track" :@(8),
            },
            @"1-9" :     @{
                @"disc" :@(1),
                @"length" :@"4:38",
                @"title" :        @{
                    @"@english" : @"Altair",
                    @"@kanji" : @"Altair",
                    @"@romaji" : @"Altair",
                },
                @"track" :@(9),
            },
        },
        @"url" :url,
        @"year" :@"2012",
    };

    [self testUsingTestData:correct
               withMetadata:YES
                  withStats:YES
                  withNotes:NO
                 withTracks:YES];
    

}

- (void)testSingleDiskStatsDifferent
{
//    return;
    NSString *name = @"statsDifferent.html";
    NSURL *url = [self getUrlForName:name];

    NSDictionary *album =@{
        @"@english": @"Atelier Rorona Character Song Album ~Kanarien~",
        @"@kanji": @"ロロナのアトリエ キャラクターソングアルバム ～カナリア～",
        @"@romaji": @"Rorona no Atelier Character Song Album ~Kanaria~"
    };

    NSArray *classification = @[@"Vocal"];

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
        @"@english" : @"Kazuki Yanagawa",
        @"@kanji"   : @"柳川和樹"
    },
    @{
        @"@english" : @"Daisuke Achiwa",
        @"@kanji"   : @"阿知波大輔"
    },
    @{
        @"@english" : @"Ken Nakagawa",
        @"@kanji"   : @"中河健"
    }
    ];

    NSArray *arranger  =@[
    @{
        @"@english" : @"Kazuki Yanagawa",
        @"@kanji"   : @"柳川和樹"
    },
    @{
        @"@english" : @"Daisuke Achiwa",
        @"@kanji"   : @"阿知波大輔"
    },
    ];

    NSArray *performer  =@[
    @{
        @"@english" : @"Kei Shindo",
        @"@kanji"   : @"真堂圭"
    },
    @{
        @"@english" : @"Eri Kitamura",
        @"@kanji"   : @"喜多村英梨"
    },
    @{
        @"@english" : @"Mai Kadowaki",
        @"@kanji"   : @"門脇舞以"
    },
    @{
        @"@english" : @"Dani",
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


    NSDictionary *correct = @{
    @"album":album,
    @"url": url,
    @"catalog" : @"KDSD-10052",
    @"date" : @"Sep 22, 2010",
    @"year": @"2010",
    @"publishedFormat": publishedFormat,
    @"price": @"2100",
    @"mediaFormat": @"CD",
    @"classification": classification,
    @"publisher": publisher,
    @"composer": composer,
    @"arranger": arranger,
    @"performer": performer,
    @"artist": composer,
    @"products": products,
    @"platforms":platforms,
    @"rating":  @"Rated 5.00 by 1 person",
    @"genre": genre,
    @"category": genre,
    };

    [self testUsingTestData:correct
               withMetadata:YES
                  withStats:NO // should be yes
                  withNotes:NO
                 withTracks:NO];
}


- (void)testDifferentProduct
{
    NSString *name = @"differentProduct.html";
    NSURL *url = [self getUrlForName:name];
    
    
    
    NSDictionary *correct =
     @{
        @"album" :@{
            @"@english" : @"My-HiME Best Collection",
            @"@kanji" : @"\u821e-HiME ~\u30d9\u30b9\u30c8\u30b3\u30ec\u30af\u30b7\u30e7\u30f3~",
            @"@romaji" : @"My-HiME Best Collection",
        },
        @"arranger" :@[
                @{
                @"@english" : @"Masaya Suzuki",
                @"@kanji" : @"\u9234\u6728\u96c5\u4e5f",
            },
                @{
                @"@english" : @"Kaoru Okubo",
                @"@kanji" : @"\u5927\u4e45\u4fdd\u85ab",
            },
                @{
                @"@english" : @"Noriyasu Agematsu",
                @"@kanji" : @"\u4e0a\u677e\u7bc4\u5eb7",
            },
                @{
                @"@english" : @"Masaaki Iizuka",
                @"@kanji" : @"\u98ef\u585a\u660c\u660e",
            }
        ],
        @"artist" :@[
                @{
                @"@english" : @"Yuki Kajiura",
                @"@kanji" : @"\u68b6\u6d66\u7531\u8a18",
            },
                @{
                @"@english" : @"Masaaki Iizuka",
                @"@kanji" : @"\u98ef\u585a\u660c\u660e",
            },
                @{
                @"@english" : @"mia",
            },
                @{
                @"@english" : @"rino",
            },
                @{
                @"@english" : @"Mika Watanabe",
                @"@kanji" : @"\u6e21\u9089\u7f8e\u4f73",
            },
                @{
                @"@english" : @"Minami Kuribayashi",
                @"@kanji" : @"\u6817\u6797\u307f\u306a\u5b9f",
            },
                @{
                @"@english" : @"Takaha Tachibana",
                @"@kanji" : @"\u6a58\u5c2d\u8449",
            },
                @{
                @"@english" : @"Mikiya Katakura",
                @"@kanji" : @"\u7247\u5009\u4e09\u8d77\u4e5f",
            },
                @{
                @"@english" : @"Masanori Takumi",
                @"@kanji" : @"\u5b85\u898b\u5c06\u5178",
            },
                @{
                @"@english" : @"Masumi Ito",
                @"@kanji" : @"\u4f0a\u85e4\u771f\u6f84",
            }
        ],
        @"catalog" :@"LACA-5465",
        @"category" :@[
            @"Game", @"Animation"
        ],
        @"classification" :@[
            @"Vocal"
        ],
        @"composer" :@[
                @{
                @"@english" : @"Yuki Kajiura",
                @"@kanji" : @"\u68b6\u6d66\u7531\u8a18",
            },
                @{
                @"@english" : @"Masaaki Iizuka",
                @"@kanji" : @"\u98ef\u585a\u660c\u660e",
            },
                @{
                @"@english" : @"mia",
            },
                @{
                @"@english" : @"rino",
            },
                @{
                @"@english" : @"Mika Watanabe",
                @"@kanji" : @"\u6e21\u9089\u7f8e\u4f73",
            },
                @{
                @"@english" : @"Minami Kuribayashi",
                @"@kanji" : @"\u6817\u6797\u307f\u306a\u5b9f",
            },
                @{
                @"@english" : @"Takaha Tachibana",
                @"@kanji" : @"\u6a58\u5c2d\u8449",
            },
                @{
                @"@english" : @"Mikiya Katakura",
                @"@kanji" : @"\u7247\u5009\u4e09\u8d77\u4e5f",
            },
                @{
                @"@english" : @"Masanori Takumi",
                @"@kanji" : @"\u5b85\u898b\u5c06\u5178",
            },
                @{
                @"@english" : @"Masumi Ito",
                @"@kanji" : @"\u4f0a\u85e4\u771f\u6f84",
            }
        ],
        @"date" :@"Dec 21, 2005",
        @"genre" :@[
            @"Game", @"Animation"
        ],
        @"mediaFormat" :@"CD",
        @"performer" :@[
                @{
                @"@english" : @"Minami Kuribayashi",
                @"@kanji" : @"\u6817\u6797\u307f\u306a\u5b9f",
            },
                @{
                @"@english" : @"Aki Misato",
                @"@kanji" : @"\u7f8e\u90f7\u3042\u304d",
            },
                @{
                @"@english" : @"Mai Nakahara",
                @"@kanji" : @"\u4e2d\u539f\u9ebb\u8863",
            },
                @{
                @"@english" : @"Saeko Chiba",
                @"@kanji" : @"\u5343\u8449\u7d17\u5b50",
            },
                @{
                @"@english" : @"Ai Shimizu",
                @"@kanji" : @"\u6e05\u6c34\u611b",
            },
                @{
                @"@english" : @"Yuko Miyamura",
                @"@kanji" : @"\u5bae\u6751\u512a\u5b50",
            },
                @{
                @"@english" : @"Yousei Teikoku",
                @"@kanji" : @"\u5996\u7cbe\u5e1d\u570b",
            },
                @{
                @"@english" : @"ALI PROJECT",
            }
        ],
        @"platforms" :@[
            @"Sony PlayStation 2"
        ],
        @"price" :@(3000),
        @"products" :@[
            @{
                @"@english" : @"MY-HiME",
            },
            @{
                @"@english" : @"MY-HiME: Unmei no Keitouju",
            },
        ],
        @"publishedFormat" :@[
            @"Commercial"
        ],
        @"publisher" :@[
                @{
                @"@english" : @"Lantis",
                @"@kanji" : @"\u682a\u5f0f\u4f1a\u793e\u30e9\u30f3\u30c6\u30a3\u30b9",
                @"@romaji" : @"Lantis",
            }
        ],
        @"rating" :@"Rated 5.00 by 1 person",
        @"totalDiscs" :@(1),
        @"totalTracks" :@(16),
        @"tracks" :@{
            @"1-1" :     @{
                @"disc" :@(1),
                @"length" :@"2:41",
                @"title" :        @{
                    @"@kanji" : @"\u5a9b\u661f",
                    @"@romaji" : @"Ensei",
                },
                @"track" :@(1),
            },
            @"1-10" :     @{
                @"disc" :@(1),
                @"length" :@"4:19",
                @"title" :        @{
                    @"@kanji" : @"last moment",
                    @"@romaji" : @"last moment",
                },
                @"track" :@(10),
            },
            @"1-11" :     @{
                @"disc" :@(1),
                @"length" :@"5:28",
                @"title" :        @{
                    @"@kanji" : @"Fortuna",
                    @"@romaji" : @"Fortuna",
                },
                @"track" :@(11),
            },
            @"1-12" :     @{
                @"disc" :@(1),
                @"length" :@"4:49",
                @"title" :        @{
                    @"@kanji" : @"\u963f\u4fee\u7f85\u59eb",
                    @"@romaji" : @"Ashura-Hime",
                },
                @"track" :@(12),
            },
            @"1-13" :     @{
                @"disc" :@(1),
                @"length" :@"4:22",
                @"title" :        @{
                    @"@kanji" : @"Silent wing",
                    @"@romaji" : @"Silent wing",
                },
                @"track" :@(13),
            },
            @"1-14" :     @{
                @"disc" :@(1),
                @"length" :@"4:35",
                @"title" :        @{
                    @"@kanji" : @"\u541b\u304c\u7a7a\u3060\u3063\u305f",
                    @"@romaji" : @"Kimi ga Sora datta",
                },
                @"track" :@(14),
            },
            @"1-15" :     @{
                @"disc" :@(1),
                @"length" :@"4:04",
                @"title" :        @{
                    @"@kanji" : @"\u79c1\u7acb\u98a8\u83ef\u5b66\u5712\u6821\u6b4c ~\u6c34\u6676\u306e\u5b88\u308a~",
                    @"@romaji" : @"Shiritsu Fuuka Gakuen Kouka ~Suisho no Mamori~",
                },
                @"track" :@(15),
            },
            @"1-16" :     @{
                @"disc" :@(1),
                @"length" :@"3:15",
                @"title" :        @{
                    @"@kanji" : @"\u821e-HiME\u30d7\u30ed\u30e2\u30fc\u30b7\u30e7\u30f3\u7528BGM",
                    @"@romaji" : @"MY-HiME Promotion-You BGM",
                },
                @"track" :@(16),
            },
            @"1-2" :     @{
                @"disc" :@(1),
                @"length" :@"4:24",
                @"title" :        @{
                    @"@kanji" : @"Shining\u2606Days",
                    @"@romaji" : @"Shining\u2606Days",
                },
                @"track" :@(2),
            },
            @"1-3" :     @{
                @"disc" :@(1),
                @"length" :@"4:33",
                @"title" :        @{
                    @"@kanji" : @"TOMORROW'S TRUE",
                    @"@romaji" : @"TOMORROW'S TRUE",
                },
                @"track" :@(3),
            },
            @"1-4" :     @{
                @"disc" :@(1),
                @"length" :@"4:43",
                @"title" :        @{
                    @"@kanji" : @"\u611b\u3057\u3055\u306e\u4ea4\u5dee\u70b9",
                    @"@romaji" : @"Itoshisa no Kousaten",
                },
                @"track" :@(4),
            },
            @"1-5" :     @{
                @"disc" :@(1),
                @"length" :@"4:50",
                @"title" :        @{
                    @"@kanji" : @"\u6c34\u8fba\u306e\u82b1",
                    @"@romaji" : @"Mizube no Hana",
                },
                @"track" :@(5),
            },
            @"1-6" :     @{
                @"disc" :@(1),
                @"length" :@"4:24",
                @"title" :        @{
                    @"@kanji" : @"\u30b3\u30b3\u30ed\u306e\u5263",
                    @"@romaji" : @"Kokoro no Tsurugi",
                },
                @"track" :@(6),
            },
            @"1-7" :     @{
                @"disc" :@(1),
                @"length" :@"2:26",
                @"title" :        @{
                    @"@kanji" : @"It's only the fairy tale",
                    @"@romaji" : @"It's only the fairy tale",
                },
                @"track" :@(7),
            },
            @"1-8" :     @{
                @"disc" :@(1),
                @"length" :@"4:36",
                @"title" :        @{
                    @"@kanji" : @"\u5c0f\u3055\u306a\u661f\u304c\u964d\u308a\u308b\u6642",
                    @"@romaji" : @"Chiisana Hoshi ga Oriru Toki",
                },
                @"track" :@(8),
            },
            @"1-9" :     @{
                @"disc" :@(1),
                @"length" :@"4:32",
                @"title" :        @{
                    @"@kanji" : @"Parade",
                    @"@romaji" : @"Parade",
                },
                @"track" :@(9),
            },
        },
        @"url" : url,
        @"year" :@"2005",
    };
    
    [self testUsingTestData:correct
               withMetadata:YES
                  withStats:YES
                  withNotes:NO
                 withTracks:YES];
    
}

#pragma mark -
#pragma mark GetTracksArray

- (void)testGetTracksArray
{
    NSString *name = @"singleDisk.html";
    NSURL *url = [self getUrlForName:name];
    NSDictionary *results =[vgmdb getAlbumData:url];
    STAssertEqualObjects(results[@"tracks"],tracksForTesting,@"Check");
    
    NSArray *sorted = [vgmdb getTracksArray:results];
    
    NSArray *correct =
    @[
    @{
        @"track": @(1),
        @"disc" : @(1),
        @"length" : @"4:18",
        @"title" :        @{
            @"@english" : @"Cross Heart",
            @"@kanji" : @"\u30af\u30ed\u30b9*\u30cf\u30fc\u30c8",
        },
    },
    @{
        @"track": @(2),
        @"disc" : @(1),
        @"length" : @"5:14",
        @"title" :        @{
            @"@english" : @"Mizutama",
            @"@kanji" : @"\u6c34\u7389",
        },
    },
    @{
        @"track": @(3),
        @"disc" : @(1),
        @"length" : @"4:18",
        @"title" :        @{
            @"@english" : @"Cross Heart (instrumental)",
            @"@kanji" : @"\u30af\u30ed\u30b9*\u30cf\u30fc\u30c8<instrumental>",
        },
    },
    @{
        @"track": @(4),
        @"disc" : @(1),
        @"length" : @"5:11",
        @"title" :        @{
            @"@english" : @"Mizutama (instrumental)",
            @"@kanji" : @"\u6c34\u7389<instrumental>",
        }
    }
    ];
    
    STAssertEqualObjects(sorted,correct,@"Sorting correct");

}


#pragma mark -
#pragma mark Setup

-(NSURL*)getUrlForName:(NSString*)name
{
    NSString *_url = [testFolder stringByAppendingPathComponent:name];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:_url];
    return url;
}


- (void)testMakeFiles
{
    return;
    NSDictionary *files =
    @{
        @"muti-disk.html":   @"http://vgmdb.net/album/13192",
        @"mutiMetadata.html":@"http://vgmdb.net/album/762",
        @"noPlatforms_small.html":@"http://vgmdb.net/album/30881",
        @"singleDisk.html":@"http://vgmdb.net/album/30880",
        @"statsDifferent" :  @"http://vgmdb.net/album/20427",
        @"different": @"http://vgmdb.net/album/32234",
//        @"10Disks": @"http://vgmdb.net/album/27827",
        @"differentProduct": @"http://vgmdb.net/album/22125"
    };
    
    for (NSString *name in files) {
        NSString *_url = files[name];
        
        NSLog(@"%@ -> %@", _url,name);
        NSError *err;
        
        NSURL *url  = [[NSURL alloc ]initWithString:_url];
        NSString *text =  [NSString stringWithContentsOfURL: url
                                                  encoding:NSUTF8StringEncoding
                                                     error:&err];
        if (!text){
            err = nil;
            text = [NSString stringWithContentsOfURLCleaned:url
                                                  error:&err];
        }
        
        NSString *path = [testFolder stringByAppendingPathComponent:[name stringByAppendingString:@".html"]];
        [text writeToFile:path
            atomically:YES
              encoding:NSUTF8StringEncoding
                 error:nil];
//        
//        id result = [vgmdb getAlbumData:[[NSURL alloc ]initFileURLWithPath:
//                                         [testFolder stringByAppendingPathComponent:[name stringByAppendingString:@".html"]]] ];
//        NSLog(@" %@", result);

    }
}



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
