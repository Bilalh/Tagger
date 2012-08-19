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

@interface VgmdbTests_10_disks : SenTestCase

@end

static Vgmdb *vgmdb;

@implementation VgmdbTests_10_disks

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
        @"artist", @"totalTracks", @"totalDisks"
        ];
        
        
        
        for (NSString *field in fields) {
            STAssertEqualObjects(
                                 [results valueForKey:field],
                                 [correct valueForKey:field],
                                 @"%@ - %@",field, name);
            printf("\n\n");
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


- (void)testTracks
{
    NSString *name = @"10Disks.html";
    NSURL *url = [self getUrlForName:name];
    NSDictionary *correct =
        @{
            @"album" : @{
                @"@english" : @"Symphonic Suite Dragon Quest Scene-Separated I~IX",
                @"@kanji" : @"\u4ea4\u97ff\u7d44\u66f2\u300c\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8\u300d\u5834\u9762\u5225 \uff29\uff5eIX\uff08\u6771\u4eac\u90fd\u4ea4\u97ff\u697d\u56e3\u7248\uff09",
                @"@romaji" : @"Koukyou Kumikyoku Dragon Quest Bamenbetsu I~IX",
            },
            @"arranger" :@[
                    @{
                    @"@english" : @"Koichi Sugiyama",
                    @"@kanji" : @"\u3059\u304e\u3084\u307e\u3053\u3046\u3044\u3061",
                }
            ],
            @"artist" :@[
                    @{
                    @"@english" : @"Koichi Sugiyama",
                    @"@kanji" : @"\u3059\u304e\u3084\u307e\u3053\u3046\u3044\u3061",
                }
            ],
            @"catalog" :@"KICC-96339~48",
            @"category" :@[
                @"Game"
            ],
            @"classification" :@[
                @"Arrangement"
            ],
            @"composer" :@[
                    @{
                    @"@english" : @"Koichi Sugiyama",
                    @"@kanji" : @"\u3059\u304e\u3084\u307e\u3053\u3046\u3044\u3061",
                }
            ],
            @"date" :@"Oct 05, 2011",
            @"genre" :@[
                @"Game"
            ],
            @"mediaFormat" :@"10 CD",
            @"performer" :@[
                    @{
                    @"@english" : @"Tokyo Metropolitan Symphony Orchestra",
                    @"@kanji" : @"\u6771\u4eac\u90fd\u4ea4\u97ff\u697d\u56e3",
                }
            ],
            @"platforms" :@[
                @"NES (Famicom)",
                @"Nintendo DS",
                @"SNES (Super Famicom)",
                @"Sony PlayStation",
                @"Sony PlayStation 2"
            ],
            @"price" :@(15750),
            @"products" :@[
                    @{
                    @"@english" : @"Dragon Warrior",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8",
                    @"@romaji" : @"Dragon Quest",
                },
                    @{
                    @"@english" : @"Dragon Warrior II",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8II: \u60aa\u970a\u306e\u795e\u3005",
                    @"@romaji" : @"Dragon Quest II: Akuryo no Kamigami",
                },
                    @{
                    @"@english" : @"Dragon Warrior III",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8III: \u305d\u3057\u3066\u4f1d\u8aac\u3078\u2026",
                    @"@romaji" : @"Dragon Quest III: Soshite Densetsu he...",
                },
                    @{
                    @"@english" : @"Dragon Quest IV: Chapters of the Chosen",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8IV: \u5c0e\u304b\u308c\u3057\u8005\u305f\u3061",
                    @"@romaji" : @"Dragon Quest IV: Michibikareshi Monotachi",
                },
                    @{
                    @"@english" : @"Dragon Quest V: Hand of the Heavenly Bride",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8V: \u5929\u7a7a\u306e\u82b1\u5ac1",
                    @"@romaji" : @"Dragon Quest V: Tenku no Hanayome",
                },
                    @{
                    @"@english" : @"Dragon Quest VI: Realms of Revelation",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8VI: \u5e7b\u306e\u5927\u5730",
                    @"@romaji" : @"Dragon Quest VI: Maboroshi no Daichi",
                },
                    @{
                    @"@english" : @"Dragon Warrior VII",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8VII: \u30a8\u30c7\u30f3\u306e\u6226\u58eb\u305f\u3061",
                    @"@romaji" : @"Dragon Quest VII: Eden no Senshi-tachi",
                },
                    @{
                    @"@english" : @"Dragon Quest VIII: Journey of the Cursed King",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8VIII: \u7a7a\u3068\u6d77\u3068\u5927\u5730\u3068\u546a\u308f\u308c\u3057\u59eb\u541b",
                    @"@romaji" : @"Dragon Quest VIII: Sora to Umi to Daichi to Norowareshi Himegimi",
                },
                    @{
                    @"@english" : @"Dragon Quest IX: Sentinels of the Starry Skies",
                    @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8IX: \u661f\u7a7a\u306e\u5b88\u308a\u4eba",
                    @"@romaji" : @"Dragon Quest IX: Hoshizora no Mamoribito",
                }
            ],
            @"publishedFormat" :@[
                @"Commercial"
            ],
            @"publisher" :@[
                    @{
                    @"@english" : @"SUGI Label",
                    @"@kanji" : @"SUGI \u30ec\u30fc\u30d9\u30eb",
                    @"@romaji" : @"SUGI Label",
                },
                    @{
                    @"@english" : @"King Records",
                    @"@kanji" : @"\u30ad\u30f3\u30b0\u30ec\u30b3\u30fc\u30c9\u682a\u5f0f\u4f1a\u793e",
                    @"@romaji" : @"King Records",
                }
            ],
            @"totalDiscs" :@(10),
            @"totalTracks" :@(187),
            @"tracks" :@{
                @"1-1" :     @{
                    @"disc" :@(1),
                    @"length" :@"3:56",
                    @"title" :        @{
                        @"@english" : @"Overture March",
                        @"@kanji" : @"\u5e8f\u66f2",
                    },
                    @"track" :@(1),
                },
                @"1-10" :     @{
                    @"disc" :@(1),
                    @"length" :@"2:41",
                    @"title" :        @{
                        @"@english" : @"Only Lonely Boy",
                        @"@kanji" : @"Love Song \u63a2\u3057\u3066",
                    },
                    @"track" :@(10),
                },
                @"1-11" :     @{
                    @"disc" :@(1),
                    @"length" :@"3:09",
                    @"title" :        @{
                        @"@english" : @"Pastoral ~ Catastrophe",
                        @"@kanji" : @"\u30d1\u30b9\u30c8\u30e9\u30fc\u30eb\uff5e\u30ab\u30bf\u30b9\u30c8\u30ed\u30d5",
                    },
                    @"track" :@(11),
                },
                @"1-12" :     @{
                    @"disc" :@(1),
                    @"length" :@"3:55",
                    @"title" :        @{
                        @"@english" : @"Prologue",
                        @"@kanji" : @"\u307e\u3069\u308d\u307f\u306e\u4e2d\u3067",
                    },
                    @"track" :@(12),
                },
                @"1-13" :     @{
                    @"disc" :@(1),
                    @"length" :@"1:20",
                    @"title" :        @{
                        @"@english" : @"Morning in Eden",
                        @"@kanji" : @"\u30a8\u30c7\u30f3\u306e\u671d",
                    },
                    @"track" :@(13),
                },
                @"1-14" :     @{
                    @"disc" :@(1),
                    @"length" :@"2:00",
                    @"title" :        @{
                        @"@english" : @"Travelling with Wagon",
                        @"@kanji" : @"\u99ac\u8eca\u3092\u66f3\u3044\u3066",
                    },
                    @"track" :@(14),
                },
                @"1-15" :     @{
                    @"disc" :@(1),
                    @"length" :@"3:42",
                    @"title" :        @{
                        @"@english" : @"Destiny ~ Prologue to Tragedy",
                        @"@kanji" : @"\u5bbf\u547d\uff5e\u60b2\u58ee\u306a\u308b\u30d7\u30ed\u30ed\u30fc\u30b0",
                    },
                    @"track" :@(15),
                },
                @"1-2" :     @{
                    @"disc" :@(1),
                    @"length" :@"1:46",
                    @"title" :        @{
                        @"@english" : @"Dragonquest March",
                        @"@kanji" : @"\u30c9\u30e9\u30b4\u30f3\u30af\u30a8\u30b9\u30c8\u30fb\u30de\u30fc\u30c1",
                    },
                    @"track" :@(2),
                },
                @"1-3" :     @{
                    @"disc" :@(1),
                    @"length" :@"1:46",
                    @"title" :        @{
                        @"@english" : @"Roto",
                        @"@kanji" : @"\u30ed\u30c8\u306e\u30c6\u30fc\u30de",
                    },
                    @"track" :@(3),
                },
                @"1-4" :     @{
                    @"disc" :@(1),
                    @"length" :@"2:03",
                    @"title" :        @{
                        @"@english" : @"Overture",
                        @"@kanji" : @"\u5e8f\u66f2",
                    },
                    @"track" :@(4),
                },
                @"1-5" :     @{
                    @"disc" :@(1),
                    @"length" :@"2:04",
                    @"title" :        @{
                        @"@english" : @"Overture",
                        @"@kanji" : @"\u5e8f\u66f2\u306e\u30de\u30fc\u30c1",
                    },
                    @"track" :@(5),
                },
                @"1-6" :     @{
                    @"disc" :@(1),
                    @"length" :@"1:58",
                    @"title" :        @{
                        @"@english" : @"Overture",
                        @"@kanji" : @"\u5e8f\u66f2\u306e\u30de\u30fc\u30c1",
                    },
                    @"track" :@(6),
                },
                @"1-7" :     @{
                    @"disc" :@(1),
                    @"length" :@"1:58",
                    @"title" :        @{
                        @"@english" : @"Overture VII",
                        @"@kanji" : @"\u5e8f\u66f2\u306e\u30de\u30fc\u30c1VII",
                    },
                    @"track" :@(7),
                },
                @"1-8" :     @{
                    @"disc" :@(1),
                    @"length" :@"1:59",
                    @"title" :        @{
                        @"@english" : @"Overture",
                        @"@kanji" : @"\u5e8f\u66f2",
                    },
                    @"track" :@(8),
                },
                @"1-9" :     @{
                    @"disc" :@(1),
                    @"length" :@"2:04",
                    @"title" :        @{
                        @"@english" : @"Overture IX",
                        @"@kanji" : @"\u5e8f\u66f2IX",
                    },
                    @"track" :@(9),
                },
                @"10-1" :     @{
                    @"disc" :@(10),
                    @"length" :@"2:43",
                    @"title" :        @{
                        @"@english" : @"Finale",
                        @"@kanji" : @"\u30d5\u30a3\u30ca\u30fc\u30ec",
                    },
                    @"track" :@(1),
                },
                @"10-10" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:07",
                    @"title" :        @{
                        @"@english" : @"Inn",
                    },
                    @"track" :@(10),
                },
                @"10-11" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:07",
                    @"title" :        @{
                        @"@english" : @"Victory",
                    },
                    @"track" :@(11),
                },
                @"10-12" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:08",
                    @"title" :        @{
                        @"@english" : @"Level Up",
                    },
                    @"track" :@(12),
                },
                @"10-13" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:08",
                    @"title" :        @{
                        @"@english" : @"Item Discovery",
                    },
                    @"track" :@(13),
                },
                @"10-14" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:12",
                    @"title" :        @{
                        @"@english" : @"Death",
                    },
                    @"track" :@(14),
                },
                @"10-15" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:08",
                    @"title" :        @{
                        @"@english" : @"Spell",
                    },
                    @"track" :@(15),
                },
                @"10-16" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:10",
                    @"title" :        @{
                        @"@english" : @"Church (Recovery)",
                    },
                    @"track" :@(16),
                },
                @"10-17" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Sleep Flute (Fairy Flute)",
                    },
                    @"track" :@(17),
                },
                @"10-18" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:15",
                    @"title" :        @{
                        @"@english" : @"Laura's Love",
                    },
                    @"track" :@(18),
                },
                @"10-19" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:13",
                    @"title" :        @{
                        @"@english" : @"Rainbow Staff (Rainbow Harp)",
                    },
                    @"track" :@(19),
                },
                @"10-2" :     @{
                    @"disc" :@(10),
                    @"length" :@"4:19",
                    @"title" :        @{
                        @"@english" : @"My Road My Journey",
                        @"@kanji" : @"\u3053\u306e\u9053\u308f\u304c\u65c5",
                    },
                    @"track" :@(2),
                },
                @"10-20" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:19",
                    @"title" :        @{
                        @"@english" : @"Rainbow Bridge (Silver Harp)",
                    },
                    @"track" :@(20),
                },
                @"10-21" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:07",
                    @"title" :        @{
                        @"@english" : @"Exit! 1",
                    },
                    @"track" :@(21),
                },
                @"10-22" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:08",
                    @"title" :        @{
                        @"@english" : @"Inn",
                    },
                    @"track" :@(22),
                },
                @"10-23" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:18",
                    @"title" :        @{
                        @"@english" : @"Comrade (Rendezvous)",
                    },
                    @"track" :@(23),
                },
                @"10-24" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:12",
                    @"title" :        @{
                        @"@english" : @"Lottery Success",
                    },
                    @"track" :@(24),
                },
                @"10-25" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:08",
                    @"title" :        @{
                        @"@english" : @"Exit! 2",
                    },
                    @"track" :@(25),
                },
                @"10-26" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:20",
                    @"title" :        @{
                        @"@english" : @"Echo Flute",
                    },
                    @"track" :@(26),
                },
                @"10-27" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:41",
                    @"title" :        @{
                        @"@english" : @"Rubiss' Protection (Shrine)",
                    },
                    @"track" :@(27),
                },
                @"10-28" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:12",
                    @"title" :        @{
                        @"@english" : @"Save (Adventure Write)",
                    },
                    @"track" :@(28),
                },
                @"10-29" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:08",
                    @"title" :        @{
                        @"@english" : @"Success",
                    },
                    @"track" :@(29),
                },
                @"10-3" :     @{
                    @"disc" :@(10),
                    @"length" :@"3:08",
                    @"title" :        @{
                        @"@english" : @"Into the Legend",
                        @"@kanji" : @"\u305d\u3057\u3066\u4f1d\u8aac\u3078",
                    },
                    @"track" :@(3),
                },
                @"10-30" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:15",
                    @"title" :        @{
                        @"@english" : @"Medium Success",
                    },
                    @"track" :@(30),
                },
                @"10-31" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:28",
                    @"title" :        @{
                        @"@english" : @"Big Success",
                    },
                    @"track" :@(31),
                },
                @"10-32" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:13",
                    @"title" :        @{
                        @"@english" : @"Cursed by the Lorelei Rock",
                    },
                    @"track" :@(32),
                },
                @"10-33" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Curse Cured",
                    },
                    @"track" :@(33),
                },
                @"10-34" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Memories of Love",
                    },
                    @"track" :@(34),
                },
                @"10-35" :     @{
                    @"disc" :@(10),
                    @"length" :@"1:26",
                    @"title" :        @{
                        @"@english" : @"Bar-Room Boogie-Woogie",
                    },
                    @"track" :@(35),
                },
                @"10-36" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:19",
                    @"title" :        @{
                        @"@english" : @"One of 6 Orbs 1",
                    },
                    @"track" :@(36),
                },
                @"10-37" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:39",
                    @"title" :        @{
                        @"@english" : @"One of 6 Orbs 2",
                    },
                    @"track" :@(37),
                },
                @"10-38" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Morning in Alefgard",
                    },
                    @"track" :@(38),
                },
                @"10-39" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:09",
                    @"title" :        @{
                        @"@english" : @"Monster Harp",
                    },
                    @"track" :@(39),
                },
                @"10-4" :     @{
                    @"disc" :@(10),
                    @"length" :@"5:14",
                    @"title" :        @{
                        @"@english" : @"Ending",
                        @"@kanji" : @"\u5c0e\u304b\u308c\u3057\u8005\u305f\u3061",
                    },
                    @"track" :@(4),
                },
                @"10-40" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:56",
                    @"title" :        @{
                        @"@english" : @"Sleeping Village",
                    },
                    @"track" :@(40),
                },
                @"10-41" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:14",
                    @"title" :        @{
                        @"@english" : @"Wake Up (Miracle)",
                    },
                    @"track" :@(41),
                },
                @"10-42" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Flute of Uncovering",
                    },
                    @"track" :@(42),
                },
                @"10-43" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:27",
                    @"title" :        @{
                        @"@english" : @"Saint Pilot-Light",
                    },
                    @"track" :@(43),
                },
                @"10-44" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:09",
                    @"title" :        @{
                        @"@english" : @"Padekia Seed",
                    },
                    @"track" :@(44),
                },
                @"10-45" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:12",
                    @"title" :        @{
                        @"@english" : @"Disease Restoration",
                    },
                    @"track" :@(45),
                },
                @"10-46" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:17",
                    @"title" :        @{
                        @"@english" : @"First Chapter Ending",
                    },
                    @"track" :@(46),
                },
                @"10-47" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:11",
                    @"title" :        @{
                        @"@english" : @"Second Chapter Ending",
                    },
                    @"track" :@(47),
                },
                @"10-48" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:13",
                    @"title" :        @{
                        @"@english" : @"Third Chapter Ending",
                    },
                    @"track" :@(48),
                },
                @"10-49" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:23",
                    @"title" :        @{
                        @"@english" : @"Fourth Chapter Ending",
                    },
                    @"track" :@(49),
                },
                @"10-5" :     @{
                    @"disc" :@(10),
                    @"length" :@"3:37",
                    @"title" :        @{
                        @"@english" : @"Bridal Waltz",
                        @"@kanji" : @"\u7d50\u5a5a\u30ef\u30eb\u30c4",
                    },
                    @"track" :@(5),
                },
                @"10-50" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:10",
                    @"title" :        @{
                        @"@english" : @"Evil Motif",
                    },
                    @"track" :@(50),
                },
                @"10-51" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:35",
                    @"title" :        @{
                        @"@english" : @"Falling Light (Blooming Flower)",
                    },
                    @"track" :@(51),
                },
                @"10-52" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:28",
                    @"title" :        @{
                        @"@english" : @"Fairy Horn",
                    },
                    @"track" :@(52),
                },
                @"10-53" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:56",
                    @"title" :        @{
                        @"@english" : @"Spring Breeze Flute",
                    },
                    @"track" :@(53),
                },
                @"10-54" :     @{
                    @"disc" :@(10),
                    @"length" :@"1:10",
                    @"title" :        @{
                        @"@english" : @"Slime Race",
                    },
                    @"track" :@(54),
                },
                @"10-55" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:10",
                    @"title" :        @{
                        @"@english" : @"Evil Motif",
                    },
                    @"track" :@(55),
                },
                @"10-56" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:15",
                    @"title" :        @{
                        @"@english" : @"Ocarina of Miracles",
                    },
                    @"track" :@(56),
                },
                @"10-57" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Mystery Harp",
                    },
                    @"track" :@(57),
                },
                @"10-58" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:10",
                    @"title" :        @{
                        @"@english" : @"Roll Entry",
                    },
                    @"track" :@(58),
                },
                @"10-59" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:39",
                    @"title" :        @{
                        @"@english" : @"Fever",
                    },
                    @"track" :@(59),
                },
                @"10-6" :     @{
                    @"disc" :@(10),
                    @"length" :@"6:54",
                    @"title" :        @{
                        @"@english" : @"Eternal Lullaby",
                        @"@kanji" : @"\u6642\u306e\u5b50\u5b88\u5504",
                    },
                    @"track" :@(6),
                },
                @"10-60" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:16",
                    @"title" :        @{
                        @"@english" : @"Listen to My Song",
                    },
                    @"track" :@(60),
                },
                @"10-61" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:17",
                    @"title" :        @{
                        @"@english" : @"Mogura's Recital",
                    },
                    @"track" :@(61),
                },
                @"10-62" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:39",
                    @"title" :        @{
                        @"@english" : @"Rinrin 1.2.3.4.5.",
                    },
                    @"track" :@(62),
                },
                @"10-63" :     @{
                    @"disc" :@(10),
                    @"length" :@"0:06",
                    @"title" :        @{
                        @"@english" : @"Monster Appearance",
                    },
                    @"track" :@(63),
                },
                @"10-7" :     @{
                    @"disc" :@(10),
                    @"length" :@"6:29",
                    @"title" :        @{
                        @"@english" : @"Triumphal Return ~ Epilogue",
                        @"@kanji" : @"\u51f1\u65cb\u305d\u3057\u3066\u30a8\u30d4\u30ed\u30fc\u30b0",
                    },
                    @"track" :@(7),
                },
                @"10-8" :     @{
                    @"disc" :@(10),
                    @"length" :@"6:21",
                    @"title" :        @{
                        @"@english" : @"Sky, Ocean and Earth",
                        @"@kanji" : @"\u7a7a\u3068\u6d77\u3068\u5927\u5730",
                    },
                    @"track" :@(8),
                },
                @"10-9" :     @{
                    @"disc" :@(10),
                    @"length" :@"6:39",
                    @"title" :        @{
                        @"@english" : @"Journey to the Star-Filled Skies ~ Defender of the Star-Filled Skies",
                        @"@kanji" : @"\u661f\u7a7a\u3078\uff5e\u661f\u7a7a\u306e\u5b88\u308a\u4eba",
                    },
                    @"track" :@(9),
                },
                @"2-1" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:27",
                    @"title" :        @{
                        @"@english" : @"Ch\u00e2teau Ladutorm",
                        @"@kanji" : @"\u30e9\u30c0\u30c8\u30fc\u30e0\u57ce",
                    },
                    @"track" :@(1),
                },
                @"2-10" :     @{
                    @"disc" :@(2),
                    @"length" :@"1:31",
                    @"title" :        @{
                        @"@english" : @"Echo of Horns throughout the Castle",
                        @"@kanji" : @"\u738b\u5bae\u306e\u30db\u30eb\u30f3",
                    },
                    @"track" :@(10),
                },
                @"2-11" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:13",
                    @"title" :        @{
                        @"@english" : @"Majestic Castle ~ Gavotte de Ch\u00e2teau ~ Majestic Castle",
                        @"@kanji" : @"\u57ce\u306e\u5a01\u5bb9\uff5e\u738b\u5bae\u306e\u30ac\u30f4\u30a9\u30c3\u30c8\uff5e\u57ce\u306e\u5a01\u5bb9",
                    },
                    @"track" :@(11),
                },
                @"2-12" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:37",
                    @"title" :        @{
                        @"@english" : @"Oboe Melody in the Castle",
                        @"@kanji" : @"\u738b\u5bae\u306e\u30aa\u30fc\u30dc\u30a8",
                    },
                    @"track" :@(12),
                },
                @"2-2" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:10",
                    @"title" :        @{
                        @"@english" : @"Ch\u00e2teau",
                        @"@kanji" : @"\u738b\u57ce",
                    },
                    @"track" :@(2),
                },
                @"2-3" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:07",
                    @"title" :        @{
                        @"@english" : @"Rondo",
                        @"@kanji" : @"\u738b\u5bae\u306e\u30ed\u30f3\u30c9",
                    },
                    @"track" :@(3),
                },
                @"2-4" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:11",
                    @"title" :        @{
                        @"@english" : @"Menuet",
                        @"@kanji" : @"\u738b\u5bae\u306e\u30e1\u30cc\u30a8\u30c3\u30c8",
                    },
                    @"track" :@(4),
                },
                @"2-5" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:36",
                    @"title" :        @{
                        @"@english" : @"The Unknown Castle",
                        @"@kanji" : @"\u8b0e\u306e\u57ce",
                    },
                    @"track" :@(5),
                },
                @"2-6" :     @{
                    @"disc" :@(2),
                    @"length" :@"2:29",
                    @"title" :        @{
                        @"@english" : @"Castle Trumpeter",
                        @"@kanji" : @"\u738b\u5bae\u306e\u30c8\u30e9\u30f3\u30da\u30c3\u30c8",
                    },
                    @"track" :@(6),
                },
                @"2-7" :     @{
                    @"disc" :@(2),
                    @"length" :@"2:58",
                    @"title" :        @{
                        @"@english" : @"Heaven",
                        @"@kanji" : @"\u5929\u7a7a\u57ce",
                    },
                    @"track" :@(7),
                },
                @"2-8" :     @{
                    @"disc" :@(2),
                    @"length" :@"3:21",
                    @"title" :        @{
                        @"@english" : @"At the Palace",
                        @"@kanji" : @"\u738b\u5bae\u306b\u3066",
                    },
                    @"track" :@(8),
                },
                @"2-9" :     @{
                    @"disc" :@(2),
                    @"length" :@"2:43",
                    @"title" :        @{
                        @"@english" : @"Saraband",
                        @"@kanji" : @"\u5c01\u5370\u3055\u308c\u3057\u57ce\u306e\u30b5\u30e9\u30d0\u30f3\u30c9",
                    },
                    @"track" :@(9),
                },
                @"3-1" :     @{
                    @"disc" :@(3),
                    @"length" :@"3:54",
                    @"title" :        @{
                        @"@english" : @"People",
                        @"@kanji" : @"\u8857\u306e\u4eba\u3005",
                    },
                    @"track" :@(1),
                },
                @"3-10" :     @{
                    @"disc" :@(3),
                    @"length" :@"2:36",
                    @"title" :        @{
                        @"@english" : @"Heavenly Village",
                        @"@kanji" : @"\u306e\u3069\u304b\u306a\u5bb6\u4e26",
                    },
                    @"track" :@(10),
                },
                @"3-11" :     @{
                    @"disc" :@(3),
                    @"length" :@"5:39",
                    @"title" :        @{
                        @"@english" : @"Peaceful Town ~ Quiet Village ~ Alchemy pot",
                        @"@kanji" : @"\u7a4f\u3084\u304b\u306a\u8857\u4e26\u307f\uff5e\u9759\u304b\u306a\u6751\uff5e\u932c\u91d1\u304c\u307e",
                    },
                    @"track" :@(11),
                },
                @"3-12" :     @{
                    @"disc" :@(3),
                    @"length" :@"2:47",
                    @"title" :        @{
                        @"@english" : @"Chatting",
                        @"@kanji" : @"\u5bfe\u8a71",
                    },
                    @"track" :@(12),
                },
                @"3-13" :     @{
                    @"disc" :@(3),
                    @"length" :@"5:51",
                    @"title" :        @{
                        @"@english" : @"Beckoning ~ Dream Vision of our Town ~ Tavern Polka ~ Beckoning",
                        @"@kanji" : @"\u6765\u305f\u308c\u308f\u304c\u8857\u3078\uff5e\u5922\u898b\u308b\u308f\u304c\u8857\uff5e\u9152\u5834\u306e\u30dd\u30eb\u30ab\uff5e\u6765\u305f\u308c\u308f\u304c\u8857\u3078",
                    },
                    @"track" :@(13),
                },
                @"3-14" :     @{
                    @"disc" :@(3),
                    @"length" :@"4:31",
                    @"title" :        @{
                        @"@english" : @"Village Bathed in Light ~ Village in Darkness",
                        @"@kanji" : @"\u967d\u3060\u307e\u308a\u306e\u6751\uff5e\u6751\u306e\u5915\u3079",
                    },
                    @"track" :@(14),
                },
                @"3-2" :     @{
                    @"disc" :@(3),
                    @"length" :@"3:36",
                    @"title" :        @{
                        @"@english" : @"Town",
                        @"@kanji" : @"\u8857\u306e\u8cd1\u308f\u3044",
                    },
                    @"track" :@(2),
                },
                @"3-3" :     @{
                    @"disc" :@(3),
                    @"length" :@"7:02",
                    @"title" :        @{
                        @"@english" : @"Around the World",
                        @"@kanji" : @"\u4e16\u754c\u3092\u307e\u308f\u308b\uff08\u8857\uff5e\u30b8\u30d1\u30f3\u30b0\uff5e\u30d4\u30e9\u30df\u30c3\u30c9\uff5e\u6751\uff09",
                    },
                    @"track" :@(3),
                },
                @"3-4" :     @{
                    @"disc" :@(3),
                    @"length" :@"2:01",
                    @"title" :        @{
                        @"@english" : @"Rolling Dice",
                        @"@kanji" : @"\u30ed\u30fc\u30ea\u30f3\u30b0\u30fb\u30c0\u30a4\u30b9",
                    },
                    @"track" :@(4),
                },
                @"3-5" :     @{
                    @"disc" :@(3),
                    @"length" :@"8:04",
                    @"title" :        @{
                        @"@english" : @"In a Town",
                        @"@kanji" : @"\u8857\u3067\u306e\u3072\u3068\u3068\u304d\uff08\u8857\uff5e\u697d\u3057\u3044\u30ab\u30b8\u30ce\uff5e\u30b3\u30ed\u30b7\u30a2\u30e0\uff5e\u8857\uff09",
                    },
                    @"track" :@(5),
                },
                @"3-6" :     @{
                    @"disc" :@(3),
                    @"length" :@"7:43",
                    @"title" :        @{
                        @"@english" : @"Melody in an Ancient Town ~ Toward the Horizon ~ Casino ~ Lively Town ~ Melody in an Ancient Town",
                        @"@kanji" : @"\u8857\u89d2\u306e\u30e1\u30ed\u30c7\u30a3\uff5e\u5730\u5e73\u306e\u5f7c\u65b9\u3078\uff5e\u30ab\u30b8\u30ce\u90fd\u5e02\uff5e\u8857\u306f\u751f\u304d\u3066\u3044\u308b\uff5e \u8857\u89d2\u306e\u30e1\u30ed\u30c7\u30a3",
                    },
                    @"track" :@(6),
                },
                @"3-7" :     @{
                    @"disc" :@(3),
                    @"length" :@"3:31",
                    @"title" :        @{
                        @"@english" : @"Sad Village ~ Mysterious Disappearance ~ Disturbed Village",
                        @"@kanji" : @"\u6dcb\u3057\u3044\u6751\uff5e\u306f\u3081\u3064\u306e\u4e88\u611f\uff5e\u3055\u3073\u308c\u305f\u6751",
                    },
                    @"track" :@(7),
                },
                @"3-8" :     @{
                    @"disc" :@(3),
                    @"length" :@"7:10",
                    @"title" :        @{
                        @"@english" : @"In the Town ~ Happy Humming ~ Inviting Village ~ Folk Dance ~ In the Town",
                        @"@kanji" : @"\u6728\u6d29\u308c\u65e5\u306e\u4e2d\u3067\uff5e\u30cf\u30c3\u30d4\u30fc\u30cf\u30df\u30f3\u30b0\uff5e\u306c\u304f\u3082\u308a\u306e\u91cc\u306b\uff5e\u30d5\u30a9\u30fc\u30af\u30c0\u30f3\u30b9\uff5e\u6728\u6d29\u308c\u65e5\u306e\u4e2d\u3067",
                    },
                    @"track" :@(8),
                },
                @"3-9" :     @{
                    @"disc" :@(3),
                    @"length" :@"7:47",
                    @"title" :        @{
                        @"@english" : @"Strolling in the Town",
                        @"@kanji" : @"\u61a9\u3044\u306e\u8857\u89d2\uff5e\u30d1\u30e9\u30c0\u30a4\u30b9\uff5e\u6642\u306e\u7720\u308b\u5712\uff5e\u3046\u305f\u3052\u306e\u5e83\u5834\uff5e\u61a9\u3044\u306e\u8857\u89d2",
                    },
                    @"track" :@(9),
                },
                @"4-1" :     @{
                    @"disc" :@(4),
                    @"length" :@"2:18",
                    @"title" :        @{
                        @"@english" : @"Unknown World",
                        @"@kanji" : @"\u5e83\u91ce\u3092\u884c\u304f",
                    },
                    @"track" :@(1),
                },
                @"4-10" :     @{
                    @"disc" :@(4),
                    @"length" :@"2:04",
                    @"title" :        @{
                        @"@english" : @"Poet's World",
                        @"@kanji" : @"\u5e83\u3044\u4e16\u754c\u3078\uff5e\u5927\u5e73\u539f\u306e\u30de\u30fc\u30c1",
                    },
                    @"track" :@(10),
                },
                @"4-11" :     @{
                    @"disc" :@(4),
                    @"length" :@"5:50",
                    @"title" :        @{
                        @"@english" : @"Hills and Meadows ~ Together in the Fields ~ Soaring in the Sky ~ Hills and Meadows",
                        @"@kanji" : @"\u8a69\u4eba\u306e\u4e16\u754c",
                    },
                    @"track" :@(11),
                },
                @"4-12" :     @{
                    @"disc" :@(4),
                    @"length" :@"2:50",
                    @"title" :        @{
                        @"@english" : @"Sandy's Theme ~ Sandy's Tears ~ Sandy's Theme",
                        @"@kanji" : @"\u91ce\u3092\u8d8a\u3048\u5c71\u3092\u8d8a\u3048\uff5e\u4ef2\u9593\u3068\u3068\u3082\u306b\uff5e\u7bb1\u821f\u306b\u4e57\u3063\u3066\uff5e\u91ce\u3092\u8d8a\u3048\u5c71\u3092\u8d8a\u3048",
                    },
                    @"track" :@(12),
                },
                @"4-13" :     @{
                    @"disc" :@(4),
                    @"length" :@"2:50",
                    @"title" :        @{
                        @"@english" : @"Distant Memories",
                        @"@kanji" : @"\u30b5\u30f3\u30c7\u30a3\u306e\u30c6\u30fc\u30de\uff5e\u30b5\u30f3\u30c7\u30a3\u306e\u6cea\uff5e\u30b5\u30f3\u30c7\u30a3\u306e\u30c6\u30fc\u30de",
                    },
                    @"track" :@(13),
                },
                @"4-14" :     @{
                    @"disc" :@(4),
                    @"length" :@"5:18",
                    @"title" :        @{
                        @"@english" : @"Over the Sorrow ~ Hurry! We are in Danger",
                        @"@kanji" : @"\u56de\u60f3",
                    },
                    @"track" :@(14),
                },
                @"4-15" :     @{
                    @"disc" :@(4),
                    @"length" :@"3:04",
                    @"title" :        @{
                        @"@english" : @"Reminiscence ~ Go Topo Go!!",
                        @"@kanji" : @"\u3064\u3089\u3044\u6642\u3092\u4e57\u308a\u8d8a\u3048\u3066\uff5e\u6025\u3052!\u30d4\u30f3\u30c1\u3060",
                    },
                    @"track" :@(15),
                },
                @"4-2" :     @{
                    @"disc" :@(4),
                    @"length" :@"5:45",
                    @"title" :        @{
                        @"@english" : @"Endless World",
                        @"@kanji" : @"\u9065\u304b\u306a\u308b\u65c5\u8def\uff5e\u5e83\u91ce\u3092\u884c\u304f\uff5e\u679c\u3066\u3057\u306a\u304d\u4e16\u754c",
                    },
                    @"track" :@(2),
                },
                @"4-3" :     @{
                    @"disc" :@(4),
                    @"length" :@"3:20",
                    @"title" :        @{
                        @"@english" : @"Adventure",
                        @"@kanji" : @"\u5192\u967a\u306e\u65c5",
                    },
                    @"track" :@(3),
                },
                @"4-4" :     @{
                    @"disc" :@(4),
                    @"length" :@"10:38",
                    @"title" :        @{
                        @"@english" : @"Comrades",
                        @"@kanji" : @"\u52c7\u8005\u306e\u4ef2\u9593\u305f\u3061\uff08\u9593\u594f\u66f2\uff5e\u6226\u58eb\u306f\u3072\u3068\u308a\u5f81\u304f\uff5e",
                    },
                    @"track" :@(4),
                },
                @"4-5" :     @{
                    @"disc" :@(4),
                    @"length" :@"5:57",
                    @"title" :        @{
                        @"@english" : @"Homeland ~ Wagon Wheel's March",
                        @"@kanji" : @"\u304a\u3066\u3093\u3070\u59eb\u306e\u884c\u9032\uff5e\u6b66\u5668\u5546\u4eba\u30c8\u30eb\u30cd\u30b3\uff5e\u30b8\u30d7\u30b7\u30fc\u30fb\u30c0\u30f3\u30b9\uff5e\u30b8\u30d7\u30b7\u30fc\u306e\u65c5\uff5e\u9593\u594f\u66f2\uff09",
                    },
                    @"track" :@(5),
                },
                @"4-6" :     @{
                    @"disc" :@(4),
                    @"length" :@"3:14",
                    @"title" :        @{
                        @"@english" : @"Pissarro",
                        @"@kanji" : @"\u52c7\u8005\u306e\u6545\u90f7\uff5e\u99ac\u8eca\u306e\u30de\u30fc\u30c1",
                    },
                    @"track" :@(6),
                },
                @"4-7" :     @{
                    @"disc" :@(4),
                    @"length" :@"5:13",
                    @"title" :        @{
                        @"@english" : @"Through the Fields ~ Wandering through the Silence ~ Another World",
                        @"@kanji" : @"\u30d4\u30b5\u30ed\uff5e\u30d4\u30b5\u30ed\u306f\u5f81\u304f",
                    },
                    @"track" :@(7),
                },
                @"4-8" :     @{
                    @"disc" :@(4),
                    @"length" :@"4:29",
                    @"title" :        @{
                        @"@english" : @"Memories of a Lost World ~ Moving through the Present",
                        @"@kanji" : @"\u3055\u3059\u3089\u3044\u306e\u30c6\u30fc\u30de\uff5e\u9759\u5bc2\u306b\u6f02\u3046\uff5e\u3082\u3046\u4e00\u3064\u306e\u4e16\u754c",
                    },
                    @"track" :@(8),
                },
                @"4-9" :     @{
                    @"disc" :@(4),
                    @"length" :@"4:25",
                    @"title" :        @{
                        @"@english" : @"Strange World ~ Marching through the Fields",
                        @"@kanji" : @"\u5931\u308f\u308c\u305f\u4e16\u754c\uff5e\u8db3\u53d6\u308a\u3082\u8efd\u3084\u304b\u306b",
                    },
                    @"track" :@(9),
                },
                @"5-1" :     @{
                    @"disc" :@(5),
                    @"length" :@"3:22",
                    @"title" :        @{
                        @"@english" : @"Dungeons",
                        @"@kanji" : @"\u6d1e\u7a9f",
                    },
                    @"track" :@(1),
                },
                @"5-10" :     @{
                    @"disc" :@(5),
                    @"length" :@"5:38",
                    @"title" :        @{
                        @"@english" : @"Shadow of Death",
                        @"@kanji" : @"\u8feb\u308a\u6765\u308b\u6b7b\u306e\u5f71",
                    },
                    @"track" :@(10),
                },
                @"5-11" :     @{
                    @"disc" :@(5),
                    @"length" :@"4:42",
                    @"title" :        @{
                        @"@english" : @"Screams from the Tower of Monsters",
                        @"@kanji" : @"\u9b54\u5854\u306e\u97ff\u304d",
                    },
                    @"track" :@(11),
                },
                @"5-12" :     @{
                    @"disc" :@(5),
                    @"length" :@"3:24",
                    @"title" :        @{
                        @"@english" : @"Cold and Gloomy ~ In the Dungeon Depths",
                        @"@kanji" : @"\u3072\u3093\u3084\u308a\u3068\u6697\u3044\u9053\uff5e\u6697\u3044\u9053\u306e\u5965\u3067",
                    },
                    @"track" :@(12),
                },
                @"5-13" :     @{
                    @"disc" :@(5),
                    @"length" :@"4:31",
                    @"title" :        @{
                        @"@english" : @"Mysterious Tower",
                        @"@kanji" : @"\u795e\u79d8\u306a\u308b\u5854",
                    },
                    @"track" :@(13),
                },
                @"5-14" :     @{
                    @"disc" :@(5),
                    @"length" :@"1:29",
                    @"title" :        @{
                        @"@english" : @"Stalked by Fear",
                        @"@kanji" : @"\u5fcd\u3073\u5bc4\u308b\u5f71",
                    },
                    @"track" :@(14),
                },
                @"5-15" :     @{
                    @"disc" :@(5),
                    @"length" :@"1:56",
                    @"title" :        @{
                        @"@english" : @"Ruins of Darkness",
                        @"@kanji" : @"\u95c7\u306e\u907a\u8de1",
                    },
                    @"track" :@(15),
                },
                @"5-16" :     @{
                    @"disc" :@(5),
                    @"length" :@"3:42",
                    @"title" :        @{
                        @"@english" : @"Nearing our Destiny",
                        @"@kanji" : @"\u7d42\u672b\u3078\u5411\u304b\u3046",
                    },
                    @"track" :@(16),
                },
                @"5-17" :     @{
                    @"disc" :@(5),
                    @"length" :@"5:29",
                    @"title" :        @{
                        @"@english" : @"Gloomy Cavern ~ Dungeon Waltz ~ Atmosphere of Death",
                        @"@kanji" : @"\u6697\u95c7\u306e\u9b54\u7a9f\uff5e\u6d1e\u7a9f\u306e\u30ef\u30eb\u30c4\uff5e\u305d\u3073\u3048\u7acb\u3064\u6b7b\u306e\u6c17\u914d",
                    },
                    @"track" :@(17),
                },
                @"5-18" :     @{
                    @"disc" :@(5),
                    @"length" :@"4:18",
                    @"title" :        @{
                        @"@english" : @"Pathway to Good Fortune ~ Cathedral of Emptiness",
                        @"@kanji" : @"\u904b\u547d\u306b\u5c0e\u304b\u308c\uff5e\u4e3b\u306a\u304d\u795e\u6bbf",
                    },
                    @"track" :@(18),
                },
                @"5-2" :     @{
                    @"disc" :@(5),
                    @"length" :@"3:48",
                    @"title" :        @{
                        @"@english" : @"Fright in Dungeon ~ Devil's Tower",
                        @"@kanji" : @"\u6050\u6016\u306e\u5730\u4e0b\u6d1e\uff5e\u9b54\u306e\u5854",
                    },
                    @"track" :@(2),
                },
                @"5-3" :     @{
                    @"disc" :@(5),
                    @"length" :@"5:34",
                    @"title" :        @{
                        @"@english" : @"Dungeon ~ Tower ~ The Phantom Ship",
                        @"@kanji" : @"\u30c0\u30f3\u30b8\u30e7\u30f3\uff5e\u5854\uff5e\u5e7d\u970a\u8239",
                    },
                    @"track" :@(3),
                },
                @"5-4" :     @{
                    @"disc" :@(5),
                    @"length" :@"3:16",
                    @"title" :        @{
                        @"@english" : @"Zoma's Castle",
                        @"@kanji" : @"\u30be\u30fc\u30de\u306e\u57ce",
                    },
                    @"track" :@(4),
                },
                @"5-5" :     @{
                    @"disc" :@(5),
                    @"length" :@"5:12",
                    @"title" :        @{
                        @"@english" : @"Frightening Dungeons ~ Cursed Towers",
                        @"@kanji" : @"\u6050\u6016\u306e\u6d1e\u7a9f\uff5e\u546a\u308f\u308c\u3057\u5854",
                    },
                    @"track" :@(5),
                },
                @"5-6" :     @{
                    @"disc" :@(5),
                    @"length" :@"6:25",
                    @"title" :        @{
                        @"@english" : @"Monsters in the Dungeon ~ Tower of Death ~ Dark World ~ Monsters in the Dungeon",
                        @"@kanji" : @"\u6d1e\u7a9f\u306b\u9b54\u7269\u306e\u5f71\u304c\uff5e\u6b7b\u306e\u5854\uff5e\u6697\u9ed2\u306e\u4e16\u754c\uff5e\u6d1e\u7a9f\u306b\u9b54\u7269\u306e\u5f71\u304c",
                    },
                    @"track" :@(6),
                },
                @"5-7" :     @{
                    @"disc" :@(5),
                    @"length" :@"4:14",
                    @"title" :        @{
                        @"@english" : @"Evil World ~ Satan's Castle ~ Frightening Dungeon ~ Satan's Castle",
                        @"@kanji" : @"\u60aa\u306e\u30e2\u30c1\u30fc\u30d5\uff5e\u30e0\u30c9\u30fc\u306e\u57ce\uff5e\u6226\u6144\u306e\u3068\u304d\uff5e\u30e0\u30c9\u30fc\u306e\u57ce",
                    },
                    @"track" :@(7),
                },
                @"5-8" :     @{
                    @"disc" :@(5),
                    @"length" :@"1:40",
                    @"title" :        @{
                        @"@english" : @"Devil's Tower",
                        @"@kanji" : @"\u8ff7\u3044\u306e\u5854",
                    },
                    @"track" :@(8),
                },
                @"5-9" :     @{
                    @"disc" :@(5),
                    @"length" :@"5:41",
                    @"title" :        @{
                        @"@english" : @"Dungeons ~ Last Dungeon ~ Dungeons",
                        @"@kanji" : @"\u6697\u95c7\u306b\u3072\u3073\u304f\u8db3\u97f3\uff5e\u30e9\u30b9\u30c8\u30c0\u30f3\u30b8\u30e7\u30f3\uff5e\u6697\u95c7\u306b\u3072\u3073\u304f\u8db3\u97f3",
                    },
                    @"track" :@(9),
                },
                @"6-1" :     @{
                    @"disc" :@(6),
                    @"length" :@"2:16",
                    @"title" :        @{
                        @"@english" : @"Requiem",
                        @"@kanji" : @"\u30ec\u30af\u30a4\u30a8\u30e0",
                    },
                    @"track" :@(1),
                },
                @"6-10" :     @{
                    @"disc" :@(6),
                    @"length" :@"5:08",
                    @"title" :        @{
                        @"@english" : @"Angelic Land",
                        @"@kanji" : @"\u5929\u306e\u7948\u308a",
                    },
                    @"track" :@(10),
                },
                @"6-11" :     @{
                    @"disc" :@(6),
                    @"length" :@"6:18",
                    @"title" :        @{
                        @"@english" : @"Gathering Place ~ Altar of Change ~ Sadness of the Heart",
                        @"@kanji" : @"\u96c6\u3048\u3001\u8005\u305f\u3061\uff5e\u7948\u308a\u306e\u8a69\uff5e\u305b\u3064\u306a\u304d\u601d\u3044",
                    },
                    @"track" :@(11),
                },
                @"6-12" :     @{
                    @"disc" :@(6),
                    @"length" :@"3:09",
                    @"title" :        @{
                        @"@english" : @"Melody of Love",
                        @"@kanji" : @"\u611b\u306e\u65cb\u5f8b",
                    },
                    @"track" :@(12),
                },
                @"6-13" :     @{
                    @"disc" :@(6),
                    @"length" :@"2:31",
                    @"title" :        @{
                        @"@english" : @"Make Me Feel Sad",
                        @"@kanji" : @"\u54c0\u6101\u7269\u8a9e",
                    },
                    @"track" :@(13),
                },
                @"6-14" :     @{
                    @"disc" :@(6),
                    @"length" :@"3:19",
                    @"title" :        @{
                        @"@english" : @"Melancholy",
                        @"@kanji" : @"\u54c0\u3057\u307f\u306e\u3068\u304d",
                    },
                    @"track" :@(14),
                },
                @"6-15" :     @{
                    @"disc" :@(6),
                    @"length" :@"4:12",
                    @"title" :        @{
                        @"@english" : @"Days of Sadness",
                        @"@kanji" : @"\u54c0\u3057\u307f\u306e\u65e5\u3005",
                    },
                    @"track" :@(15),
                },
                @"6-16" :     @{
                    @"disc" :@(6),
                    @"length" :@"3:16",
                    @"title" :        @{
                        @"@english" : @"To My Loved One",
                        @"@kanji" : @"\u611b\u3059\u308b\u4eba\u3078",
                    },
                    @"track" :@(16),
                },
                @"6-17" :     @{
                    @"disc" :@(6),
                    @"length" :@"2:56",
                    @"title" :        @{
                        @"@english" : @"Sacrifice Dance",
                        @"@kanji" : @"\u30c8\u30a5\u30fc\u30e9\u306e\u821e\uff5e\u5fa9\u6d3b\u306e\u3044\u306e\u308a",
                    },
                    @"track" :@(17),
                },
                @"6-18" :     @{
                    @"disc" :@(6),
                    @"length" :@"4:38",
                    @"title" :        @{
                        @"@english" : @"With Sadness in Heart ~ A Safe Haven",
                        @"@kanji" : @"\u54c0\u3057\u307f\u3092\u80f8\u306b\uff5e\u3084\u3059\u3089\u304e\u306e\u5730",
                    },
                    @"track" :@(18),
                },
                @"6-19" :     @{
                    @"disc" :@(6),
                    @"length" :@"5:52",
                    @"title" :        @{
                        @"@english" : @"Remembrances...",
                        @"@kanji" : @"\u3053\u306e\u60f3\u3044\u3092\u2026",
                    },
                    @"track" :@(19),
                },
                @"6-2" :     @{
                    @"disc" :@(6),
                    @"length" :@"1:48",
                    @"title" :        @{
                        @"@english" : @"Holy Shrine",
                        @"@kanji" : @"\u8056\u306a\u308b\u307b\u3053\u3089",
                    },
                    @"track" :@(2),
                },
                @"6-3" :     @{
                    @"disc" :@(6),
                    @"length" :@"2:54",
                    @"title" :        @{
                        @"@english" : @"Requiem ~ Small Shrine",
                        @"@kanji" : @"\u93ae\u9b42\u6b4c\uff5e\u307b\u3053\u3089",
                    },
                    @"track" :@(3),
                },
                @"6-4" :     @{
                    @"disc" :@(6),
                    @"length" :@"5:07",
                    @"title" :        @{
                        @"@english" : @"Elegy ~ Mysterious Shrine",
                        @"@kanji" : @"\u30a8\u30ec\u30b8\u30fc\uff5e\u4e0d\u601d\u8b70\u306e\u307b\u3053\u3089",
                    },
                    @"track" :@(4),
                },
                @"6-5" :     @{
                    @"disc" :@(6),
                    @"length" :@"5:22",
                    @"title" :        @{
                        @"@english" : @"Noble Requiem ~ Saint",
                        @"@kanji" : @"\u9ad8\u8cb4\u306a\u308b\u30ec\u30af\u30a4\u30a8\u30e0\uff5e\u8056",
                    },
                    @"track" :@(5),
                },
                @"6-6" :     @{
                    @"disc" :@(6),
                    @"length" :@"2:01",
                    @"title" :        @{
                        @"@english" : @"Ocarina ~ The Saint ~ Ocarina",
                        @"@kanji" : @"\u5947\u8de1\u306e\u30aa\u30ab\u30ea\u30ca\uff5e\u795e\u306b\u7948\u308a\u3092\uff5e\u5947\u8e5f\u306e\u30aa\u30ab\u30ea\u30ca",
                    },
                    @"track" :@(6),
                },
                @"6-7" :     @{
                    @"disc" :@(6),
                    @"length" :@"3:49",
                    @"title" :        @{
                        @"@english" : @"Sphinx ~ Mysterious Sanctuary",
                        @"@kanji" : @"\u30b9\u30d5\u30a3\u30f3\u30af\u30b9\uff5e\u5927\u795e\u6bbf",
                    },
                    @"track" :@(7),
                },
                @"6-8" :     @{
                    @"disc" :@(6),
                    @"length" :@"4:09",
                    @"title" :        @{
                        @"@english" : @"Healing Power of the Psalms ~ Friar's Determination",
                        @"@kanji" : @"\u8b83\u7f8e\u6b4c\u306b\u7652\u3055\u308c\u3066\uff5e\u4fee\u9053\u50e7\u306e\u6c7a\u610f",
                    },
                    @"track" :@(8),
                },
                @"6-9" :     @{
                    @"disc" :@(6),
                    @"length" :@"3:06",
                    @"title" :        @{
                        @"@english" : @"Sanctuary",
                        @"@kanji" : @"\u5927\u8056\u5802\u306e\u3042\u308b\u8857",
                    },
                    @"track" :@(9),
                },
                @"7-1" :     @{
                    @"disc" :@(7),
                    @"length" :@"2:16",
                    @"title" :        @{
                        @"@english" : @"Beyond the Waves",
                        @"@kanji" : @"\u6d77\u539f\u3092\u884c",
                    },
                    @"track" :@(1),
                },
                @"7-10" :     @{
                    @"disc" :@(7),
                    @"length" :@"3:53",
                    @"title" :        @{
                        @"@english" : @"Aboard Ship ~ Pirates of the Sea",
                        @"@kanji" : @"\u5c0f\u821f\u306b\u63fa\u3089\u308c\u3066\uff5e\u6d77\u539f\u306e\u738b\u8005",
                    },
                    @"track" :@(10),
                },
                @"7-11" :     @{
                    @"disc" :@(7),
                    @"length" :@"3:19",
                    @"title" :        @{
                        @"@english" : @"Magic Carpet",
                        @"@kanji" : @"\u9b54\u6cd5\u306e\u3058\u3085\u3046\u305f\u3093",
                    },
                    @"track" :@(11),
                },
                @"7-12" :     @{
                    @"disc" :@(7),
                    @"length" :@"3:43",
                    @"title" :        @{
                        @"@english" : @"Over the Horizon",
                        @"@kanji" : @"\u9065\u304b\u306a\u308b\u7a7a\u306e\u5f7c\u65b9\u3078",
                    },
                    @"track" :@(12),
                },
                @"7-13" :     @{
                    @"disc" :@(7),
                    @"length" :@"4:17",
                    @"title" :        @{
                        @"@english" : @"Memories of an Ancient Ocean",
                        @"@kanji" : @"\u6d77\u306e\u8a18\u61b6",
                    },
                    @"track" :@(13),
                },
                @"7-2" :     @{
                    @"disc" :@(7),
                    @"length" :@"2:50",
                    @"title" :        @{
                        @"@english" : @"Sailing",
                        @"@kanji" : @"\u6d77\u3092\u8d8a\u3048\u3066",
                    },
                    @"track" :@(2),
                },
                @"7-3" :     @{
                    @"disc" :@(7),
                    @"length" :@"2:53",
                    @"title" :        @{
                        @"@english" : @"Heavenly Flight",
                        @"@kanji" : @"\u304a\u304a\u305e\u3089\u3092\u3068\u3076",
                    },
                    @"track" :@(3),
                },
                @"7-4" :     @{
                    @"disc" :@(7),
                    @"length" :@"4:28",
                    @"title" :        @{
                        @"@english" : @"Balloon's Flight",
                        @"@kanji" : @"\u306e\u3069\u304b\u306a\u71b1\u6c17\u7403\u306e\u305f\u3073",
                    },
                    @"track" :@(4),
                },
                @"7-5" :     @{
                    @"disc" :@(7),
                    @"length" :@"4:41",
                    @"title" :        @{
                        @"@english" : @"Sea Breeze",
                        @"@kanji" : @"\u6d77\u56f3\u3092\u5e83\u3052\u3066",
                    },
                    @"track" :@(5),
                },
                @"7-6" :     @{
                    @"disc" :@(7),
                    @"length" :@"7:19",
                    @"title" :        @{
                        @"@english" : @"Magic Carpet ~ The Ocean",
                        @"@kanji" : @"\u7a7a\u98db\u3076\u7d68\u6bef\uff5e\u5927\u6d77\u539f\u3078",
                    },
                    @"track" :@(6),
                },
                @"7-7" :     @{
                    @"disc" :@(7),
                    @"length" :@"5:09",
                    @"title" :        @{
                        @"@english" : @"Ocean Waves",
                        @"@kanji" : @"\u30a8\u30fc\u30b2\u6d77\u306b\u8239\u51fa\u3057\u3066",
                    },
                    @"track" :@(7),
                },
                @"7-8" :     @{
                    @"disc" :@(7),
                    @"length" :@"2:08",
                    @"title" :        @{
                        @"@english" : @"Flying Bed",
                        @"@kanji" : @"\u7a7a\u98db\u3076\u30d9\u30c3\u30c9",
                    },
                    @"track" :@(8),
                },
                @"7-9" :     @{
                    @"disc" :@(7),
                    @"length" :@"5:23",
                    @"title" :        @{
                        @"@english" : @"Pegasus ~ Saint's Wreath",
                        @"@kanji" : @"\u30da\u30ac\u30b5\u30b9\uff5e\u7cbe\u970a\u306e\u51a0",
                    },
                    @"track" :@(9),
                },
                @"8-1" :     @{
                    @"disc" :@(8),
                    @"length" :@"2:07",
                    @"title" :        @{
                        @"@english" : @"Fight",
                        @"@kanji" : @"\u6226\u95d8",
                    },
                    @"track" :@(1),
                },
                @"8-2" :     @{
                    @"disc" :@(8),
                    @"length" :@"3:09",
                    @"title" :        @{
                        @"@english" : @"King Dragon",
                        @"@kanji" : @"\u7adc\u738b",
                    },
                    @"track" :@(2),
                },
                @"8-3" :     @{
                    @"disc" :@(8),
                    @"length" :@"3:57",
                    @"title" :        @{
                        @"@english" : @"Deathfight ~ Dead or Alive",
                        @"@kanji" : @"\u6226\u3044\uff5e\u6b7b\u3092\u8ced\u3057\u3066",
                    },
                    @"track" :@(3),
                },
                @"8-4" :     @{
                    @"disc" :@(8),
                    @"length" :@"4:08",
                    @"title" :        @{
                        @"@english" : @"Gruelling Fight",
                        @"@kanji" : @"\u6226\u3044\u306e\u3068\u304d",
                    },
                    @"track" :@(4),
                },
                @"8-5" :     @{
                    @"disc" :@(8),
                    @"length" :@"5:50",
                    @"title" :        @{
                        @"@english" : @"Fighting Spirit",
                        @"@kanji" : @"\u6226\u95d8\u306e\u30c6\u30fc\u30de\uff5e\u30a2\u30ec\u30d5\u30ac\u30eb\u30c9\u306b\u3066\uff5e\u52c7\u8005\u306e\u6311\u6226",
                    },
                    @"track" :@(5),
                },
                @"8-6" :     @{
                    @"disc" :@(8),
                    @"length" :@"3:25",
                    @"title" :        @{
                        @"@english" : @"Tough Enemy",
                        @"@kanji" : @"\u7acb\u3061\u306f\u3060\u304b\u308b\u96e3\u6575",
                    },
                    @"track" :@(6),
                },
                @"8-7" :     @{
                    @"disc" :@(8),
                    @"length" :@"7:59",
                    @"title" :        @{
                        @"@english" : @"Battle for the Glory",
                        @"@kanji" : @"\u6804\u5149\u3078\u306e\u6226\u3044\uff08\u6226\u95d8\uff5e\u90aa\u60aa\u306a\u308b\u3082\u306e\uff5e\u60aa\u306e\u5316\u8eab\uff09",
                    },
                    @"track" :@(7),
                },
                @"8-8" :     @{
                    @"disc" :@(8),
                    @"length" :@"5:55",
                    @"title" :        @{
                        @"@english" : @"Violent Enemies ~ Almighty Boss Devil is Challenged",
                        @"@kanji" : @"\u6226\u706b\u3092\u4ea4\u3048\u3066\uff5e\u4e0d\u6b7b\u8eab\u306e\u6575\u306b\u6311\u3080",
                    },
                    @"track" :@(8),
                },
                @"8-9" :     @{
                    @"disc" :@(8),
                    @"length" :@"4:43",
                    @"title" :        @{
                        @"@english" : @"Satan",
                        @"@kanji" : @"\u5927\u9b54\u738b\uff0fSatan (\u2164)",
                    },
                    @"track" :@(9),
                },
                @"9-1" :     @{
                    @"disc" :@(9),
                    @"length" :@"6:19",
                    @"title" :        @{
                        @"@english" : @"Brave Fight",
                        @"@kanji" : @"\u52c7\u6c17\u3042\u308b\u6226\u3044\uff5e\u6562\u7136\u3068\u7acb\u3061\u5411\u304b\u3046",
                    },
                    @"track" :@(1),
                },
                @"9-2" :     @{
                    @"disc" :@(9),
                    @"length" :@"4:33",
                    @"title" :        @{
                        @"@english" : @"Monsters",
                        @"@kanji" : @"\u9b54\u7269\u51fa\u73fe",
                    },
                    @"track" :@(2),
                },
                @"9-3" :     @{
                    @"disc" :@(9),
                    @"length" :@"5:23",
                    @"title" :        @{
                        @"@english" : @"Demon Combat",
                        @"@kanji" : @"\u9b54\u738b\u3068\u306e\u5bfe\u6c7a",
                    },
                    @"track" :@(3),
                },
                @"9-4" :     @{
                    @"disc" :@(9),
                    @"length" :@"5:46",
                    @"title" :        @{
                        @"@english" : @"Fighting Spirit ~ World of the Strong",
                        @"@kanji" : @"\u8840\u8def\u3092\u958b\u3051\uff5e\u5f37\u304d\u8005\u3069\u3082",
                    },
                    @"track" :@(4),
                },
                @"9-5" :     @{
                    @"disc" :@(9),
                    @"length" :@"3:41",
                    @"title" :        @{
                        @"@english" : @"Orgo Demila",
                        @"@kanji" : @"\u30aa\u30eb\u30b4\u30fb\u30c7\u30df\u30fc\u30e9",
                    },
                    @"track" :@(5),
                },
                @"9-6" :     @{
                    @"disc" :@(9),
                    @"length" :@"3:47",
                    @"title" :        @{
                        @"@english" : @"War Cry ~ Defeat the Enemy",
                        @"@kanji" : @"\u96c4\u53eb\u3073\u3092\u3042\u3052\u3066\uff5e\u96e3\u95a2\u3092\u7a81\u7834\u305b\u3088",
                    },
                    @"track" :@(6),
                },
                @"9-7" :     @{
                    @"disc" :@(9),
                    @"length" :@"7:10",
                    @"title" :        @{
                        @"@english" : @"Dormaguez ~ Great Battle in the Vast Sky",
                        @"@kanji" : @"\u30c9\u30eb\u30de\u30b2\u30b9\uff5e\u304a\u304a\u305e\u3089\u306b\u6226\u3046",
                    },
                    @"track" :@(7),
                },
                @"9-8" :     @{
                    @"disc" :@(9),
                    @"length" :@"5:17",
                    @"title" :        @{
                        @"@english" : @"Build-up to Victory ~ Confused Ambitions",
                        @"@kanji" : @"\u8ca0\u3051\u308b\u3082\u306e\u304b\uff5e\u6e26\u5dfb\u304f\u6b32\u671b",
                    },
                    @"track" :@(8),
                },
                @"9-9" :     @{
                    @"disc" :@(9),
                    @"length" :@"4:16",
                    @"title" :        @{
                        @"@english" : @"Final Battle",
                        @"@kanji" : @"\u6c7a\u6226\u306e\u6642",
                    },
                    @"track" :@(9),
                },
            },
            @"url" :url,
            @"year" :@"2011",
        };
    
    [self testUsingTestData:correct
               withMetadata:YES
                  withStats:YES
                  withNotes:NO
                 withTracks:YES];
    
}


-(NSURL*)getUrlForName:(NSString*)name
{
    NSString *_url = [testFolder stringByAppendingPathComponent:name];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:_url];
    return url;
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