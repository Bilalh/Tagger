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
NSString  *testFolder = @"/Users/bilalh/Projects/Tagger/Test Files/Albums/";

@interface VgmdbTests : SenTestCase

@end

Vgmdb *vgmdb;

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
               withMetadata:YES
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

NSUInteger encodings[] =  {
    NSUTF8StringEncoding,
    NSISOLatin1StringEncoding
//    NSASCIIStringEncoding,
//    NSISOLatin1StringEncoding,
//    NSShiftJISStringEncoding,
//    NSNEXTSTEPStringEncoding,
//    NSJapaneseEUCStringEncoding,
//    NSISO2022JPStringEncoding,
//    NSSymbolStringEncoding,
//    NSNonLossyASCIIStringEncoding,
//    NSISOLatin2StringEncoding,
//    NSUnicodeStringEncoding,
//    NSWindowsCP1251StringEncoding,
//    NSWindowsCP1252StringEncoding,
//    NSWindowsCP1253StringEncoding,
//    NSWindowsCP1254StringEncoding,
//    NSWindowsCP1250StringEncoding,
//    NSMacOSRomanStringEncoding
};

- (void)testMakeFiles
{
    NSDictionary *files =
    @{
        @"all_blank" : @"/Users/bilalh/20427.html" //@"http://vgmdb.net/album/32234"
    };
    
    for (NSString *name in files) {
        NSString *_url = files[name];
        
        NSLog(@"%@ -> %@", _url,name);
        NSError *err;
        
        
        NSString *s;
        NSStringEncoding enc = NSISOLatin1StringEncoding;
//        for (int i =0; i < sizeof(encodings)/sizeof(size_t); i++) {
//            enc = encodings[i];
//            s=  [NSString stringWithContentsOfURL:[[NSURL alloc ]initFileURLWithPath:_url]
//                                                   encoding:enc
//                                                      error:&err];
//            if (!err){
//                NSString *path = [testFolder stringByAppendingPathComponent:[name stringByAppendingFormat:@"%lul .html",enc ]];
//                [s writeToFile:path
//                    atomically:YES
//                      encoding:NSUTF8StringEncoding
//                         error:nil];
//            }else{
//                 NSLog(@"err %@", err);
//            }
//        }
        
        
        s=  [NSString stringWithContentsOfURL:[[NSURL alloc ]initFileURLWithPath:_url]
                                                  encoding:enc
                                                     error:&err];
        
        NSString *correct  = [NSString stringWithContentsOfURL:[[NSURL alloc ]initFileURLWithPath:@"/Users/bilalh/32234z correct.html"]
                                     encoding:enc
                                        error:&err];
        
//        NSRange r =[s rangeOfString:@"\u00E5\u00A3."];
//        if (r.location != NSNotFound ){
//            s = [s stringByReplacingCharactersInRange:r withString:@""];
//            NSLog(@"!!!!!!");
//        }
    
        NSString *nn = [s stringByReplacingOccurrencesOfRegex:@"å£." withString:@""];
        NSString *ne = [s stringByReplacingOccurrencesOfString:@"å£." withString:@""];
        
        NSLog(@"equal %ul",[s isEqualToString:ne]);
        NSLog(@"size correct:%zu s:%zu nn:%zu ne:%zu",[correct length], [s length], [nn length], [ne length]);
        
        NSString *res = [NSString stringWithCString:[nn cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
        NSString *res2 = [NSString stringWithCString:[ne cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
        NSString *res3 = [NSString stringWithCString:[correct cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
        NSString *res_s = [NSString stringWithCString:[s cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
        NSLog(@"res_nn %d", res != nil);
        NSLog(@"res_ne %d", res2 != nil);
        NSLog(@"res_co %d", res3 != nil);
        NSLog(@"res_s %d", res_s != nil);

        
        NSString *path = [testFolder stringByAppendingPathComponent:[name stringByAppendingString:@".html"]];
        [ne writeToFile:path
            atomically:YES
              encoding:NSISOLatin1StringEncoding
                 error:nil];

        NSLog(@"!%@ -> %@ DONE using enc:%lu", _url,name,enc);
        
//        id result = [vgmdb getAlbumData:[[NSURL alloc ]initFileURLWithPath:[testFolder stringByAppendingPathComponent:[name stringByAppendingString:@".html"]]] ];
//        NSLog(@" %@", result);
        NSData *bytes= [s dataUsingEncoding:NSISOLatin1StringEncoding];
        NSData *cleaned = [self cleanUTF8:bytes];
        NSString *ss = [[NSString alloc] initWithData:cleaned encoding:NSUTF8StringEncoding];
        NSLog(@"%@",ss);
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


- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // convert to UTF-8 from UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // discard invalid characters
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = (char*) malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}

@end
