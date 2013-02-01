//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#import "Vgmdb.h"
#import "Vgmdb+private.h"


#import "NSString+Convert.h"
#import "NSString+Regex.h"
#import "RegexKitLite.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);

#include <string>
#include <iostream>
#include <set>
#include <list>
#include <map>

#include <htmlcxx/html/ParserDom.h>

#include "hcxselect.h"
#include "VgmdbStruct.h"


static const NSDictionary *namesMap;

using namespace std;
using namespace hcxselect;


@implementation Vgmdb

#pragma mark -
#pragma mark init


- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (void)initialize
{
    namesMap = [NSDictionary dictionaryWithObjectsAndKeys:
                @"english", @"en",
                @"kanji",   @"ja",
                @"romaji",  @"ja-Latn",
                @"english", @"English",
                @"kanji",   @"Japanese",
                @"romaji",  @"Romaji",
                @"latin",   @"Latin",
                @"english_offical",   @"English (Official)",
                @"english_literal",   @"English Literal",
                nil];
}

#pragma mark -
#pragma mark Searching 

- (id) searchResults:(NSString*)search
{
    NSString *baseUrl = @"http://vgmdb.net/search?q=";
    NSString *tmp = [baseUrl stringByAppendingString:search];
    NSString *_url = [tmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self _searchResults: [NSURL URLWithString:_url] ];
}

- (id) _searchResults:(NSURL*)url
{
    DDLogInfo(@"Searching using URL %@", url);
    NSError *err = nil;
    string *html  = [self cppstringWithContentsOfURL:url
                                              error:&err
                                            encoding:NSUTF8StringEncoding];
    
    if (!err){
        htmlcxx::HTML::ParserDom parser;
        tree<htmlcxx::HTML::Node> dom = parser.parseTree(*html);
        Selector s(dom);
        
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        Selector res = s.select("div#albumresults tbody > tr");
        
        // Handles a single result (which redirects directly to the album.
        if (res.empty()){
            Selector test = s.select("ul#tlnav");
            if (test.empty()){
                return [NSNull null];
            }
            Selector surl = s.select("head>link:first-of-type");
            Selector::iterator iurl = surl.begin();
            Node *nurl = *iurl;
            nurl->data.parseAttributes();
            map<string, string> att= nurl->data.attributes();
            string _url = att["href"];
            NSString *url = [NSString stringWithCppStringTrimmed:&_url];
            url = [url stringByReplacingOccurrencesOfString:@"/feed" withString:@""];
            return [self getAlbumData:[NSURL URLWithString:url]];
        }
        
        Selector::iterator it = res.begin();    
        for (; it != res.end(); ++it) {
//            [self printNode:*it inHtml:html];
            
            Node *catalog_td = (*it)->first_child;
            string _catalog = catalog_td->first_child->first_child->data.text();
            NSString *catalog = [[NSString alloc] initWithCppString:&_catalog];
            
            Node *title_td = catalog_td->next_sibling->next_sibling;
            Node *first_title = title_td->first_child->first_child;
            NSDictionary *album =[self splitLanguagesInNodes:first_title];
            
            Node *url_a = title_td->first_child;
            url_a->data.parseAttributes();
            map<string, string> att= url_a->data.attributes();
            string _url = att["href"];
            NSString *url = [[NSString alloc] initWithCppString:&_url];
            
            Node *year_td = title_td->next_sibling;
            Node *year_t = year_td;
            while(year_t->data.isTag()){
                year_t = year_t->first_child;
            }
            
            
            string _year = year_t->data.text();
            NSString *year = [[NSString alloc] initWithCppString:&_year];

            [rows addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             catalog, @"catalog" ,
                             year,    @"released",
                             album,   @"album",
                             url,     @"url",
                             nil]];
        }
        
        delete html;
        return rows; 
        
    }else {
        DDLogInfo(@"%@", [err localizedFailureReason]);
    }
    
    delete html;
    return [NSArray new];
}

#pragma mark -
#pragma mark Album data


- (NSDictionary*)getAlbumData:(NSURL*) url
{
    return [self getAlbumData:url encoding:NSUTF8StringEncoding];
}

- (NSDictionary*)getAlbumData:(NSURL*) url
                     encoding:(NSStringEncoding)encoding
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    NSError *err;
    string *html = [self cppstringWithContentsOfURL:url error:&err encoding:encoding];
    
    if (html == NULL){
        DDLogError(@"Error %@", [err localizedDescription]);
        return data;
    }
    
    htmlcxx::HTML::ParserDom parser;
    tree<htmlcxx::HTML::Node> dom = parser.parseTree(*html);
    Selector s(dom);
    
    [data setValue:[self getAlbumTitles:dom forHtml:*html]
            forKey:@"album"];
    
    _html = *html;
    [self storeMetadata:dom forHtml:*html in:data];
    [self storeStats:dom forHtml:*html in:data];
    [self storeNotes:dom forHtml:*html in:data];
    [self storeTracks:dom forHtml:*html in:data];
    
    delete html;
    [data setValue:url forKey:@"url"];
    return data;
}


- (void) storeTracks:(const tree<htmlcxx::HTML::Node>&)dom
            forHtml:(const std::string&)html
                 in:(NSDictionary*)data
{
    
    Selector s(dom);
    NSMutableArray *refs = [NSMutableArray new];
    Selection res = s.select("ul#tlnav>li>a");
    
    for (Selector::iterator it = res.begin(); it != res.end(); ++it) {
        Node *n =*it;
        string text =n->first_child->data.text();
        
        NSString *_lang = [NSString stringWithCppStringTrimmed:&text];
        NSString *lang = [namesMap objectForKey:_lang];
        
        n->data.parseAttributes();
        map<string, string> att= n->data.attributes();
        map<string, string>::iterator itLang= att.find("rel");
        
        string _rel  = itLang->second;
        NSString *rel =  [NSString stringWithCppStringTrimmed:&_rel];
        assert(lang != nil);
        NSDictionary *map = @{ @"lang" : lang, @"ref" : rel };
        [refs addObject:map];
    }
    
    NSMutableDictionary *tracks = [NSMutableDictionary new];
    
    int totalTracks = 0;
    for (NSDictionary *ref in refs) {
        NSString *_sel = [NSString stringWithFormat:@"span#%@>table", [ref valueForKey:@"ref"]];
        
        string *sel = [_sel cppString];
        Selector discTables = s.select(*sel);
        delete sel;
        
        unsigned long num_discs = discTables.size();
        [data setValue:@(num_discs) forKey:@"totalDiscs"];
        
        int disc_num = 1;
        for (Selector::iterator it = discTables.begin(); it != discTables.end(); ++it) {
            Node *disc = *it;
            Node *track_tr = disc->first_child;
            
            while (track_tr) {
                if (!track_tr->data.isTag()) {
                    track_tr = track_tr->next_sibling;
                    continue;
                }
                
                Node *track_num = track_tr->first_child->next_sibling;
                string _num = track_num->first_child->first_child ->data.text();
                long num = strtol(_num.c_str(),NULL, 10);
                
                
                Node *trackTitle = track_num->next_sibling->next_sibling;
                NSString *title = [[self textFromNode:trackTitle] stringByDecodingXMLEntities];
                
                NSString *key = [NSString stringWithFormat:@"%d-%ld",disc_num,num];
                NSDictionary *track = [tracks valueForKey:key];
                
                if (!track){
                    Node *trackLen = trackTitle->next_sibling->next_sibling;
                    NSString *len = [self textFromNode:trackLen];
                    if ([len  stringByMatching:@"(.*<span.*?time.>)"] != NULL){
                        len = @"?:??";
                    }
                    track = @{
                    @"title":  [NSMutableDictionary new],
                    @"track":  @(num),
                    @"disc":   @(disc_num),
                    @"length": len
                    };
                    [tracks setValue:track forKey:key];
                    totalTracks++;
                }
                
                [[track valueForKey:@"title"] setValue:title forKey:[ref valueForKey:@"lang"]];
                
                track_tr = track_tr->next_sibling;
            }
            
            
            disc_num++;
        }
        [data setValue:tracks forKey:@"tracks"];
    }
    [data setValue:@(totalTracks) forKey:@"totalTracks"];
    
}


- (void) storeNotes:(const tree<htmlcxx::HTML::Node>&)dom
            forHtml:(const std::string&)html
                    in:(NSDictionary*)data
{
    Selector s(dom);
    Selector res = s.select("div.page > table > tr > td > div > div[style].smallfont");
    if (res.size() ==0) return;
    
    string buf;
    Node *n = *res.rbegin();
    n = n->first_child;
    
    while (n){
        if (!n->data.isTag()){
            buf.append( n->data.text());
        }else if(n->data.tagName().compare("br") ==0){
            buf.append("\n");
        }
        n= n->next_sibling;
    }
    
    NSString *notes = [[NSString stringWithCppStringTrimmed: &buf] stringByDecodingXMLEntities];
    [data setValue:notes forKey:@"comment"];
}

- (NSDictionary*) getAlbumTitles:(const tree<htmlcxx::HTML::Node>&)dom
                         forHtml:(const std::string&)html
{
    Selector s(dom);
    Selector res = s.select("h1>span.albumtitle");
    Node *n = *res.begin();
//    [self printNode:n inHtml:html];
    NSDictionary *titles = [self splitLanguagesInNodes:n];
    
    return titles;
}


string _html;

- (void) storeMetadata:(const tree<htmlcxx::HTML::Node>&)dom
               forHtml:(const std::string&)html
                in:(NSDictionary*)data
{

    Selector s(dom);
    Selector meta = s.select("table#album_infobit_large");
//    cout<< meta.size();
    /* Catalog */
    Selector catalogElem = meta.select("tr td[width='100%']");
    Node *ncat = *catalogElem.begin();
//    cout<< catalogElem.size();
    string _catalog = ncat->first_child->data.text();
    NSString *catalog = [NSString stringWithCppStringTrimmed:&_catalog];
    [data setValue:catalog forKey:@"catalog"];
    
    Node *m = *meta.begin();
    
    // Get the text value of the specifed node
    NSString* (^get_data)(Node*) = ^(Node *n){
        Node *m = n->last_child;
        while (m->data.isTag()) {
            m = m ->first_child;
        }
        string temp =  m->data.text();
        return [NSString stringWithCppStringTrimmed:&temp];
	};
    
    Node *ndate = m->first_child->next_sibling->next_sibling->next_sibling;
    NSString *date = get_data(ndate);
    [data setValue:date forKey:@"date"];
    
    NSRegularExpression* dateRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d{4}$"
                                                                               options:0
                                                                                 error:nil];
    NSTextCheckingResult *yresult =[dateRegex firstMatchInString:date
                                                    options:0
                                                      range:NSMakeRange(0, [date length])];
    NSString *year = [date substringWithRange:yresult.range];
    [data setValue:year forKey:@"year"];
    
    
    Node *npub = ndate->next_sibling->next_sibling;
    NSString *pub = get_data(npub);
    [data setValue:[self spiltMutiMetadataString:pub] forKey:@"publishedFormat"];
    
    Node *nprice = npub->next_sibling->next_sibling;
    [data setValue:get_data(nprice) forKey:@"price"];

    Node *nfor = nprice->next_sibling->next_sibling;
    [data setValue:get_data(nfor) forKey:@"mediaFormat"];
    
    Node *nclas = nfor->next_sibling->next_sibling;
    NSString *clas = get_data(nclas);
    [data setValue:[self spiltMutiMetadataString:clas] forKey:@"classification"];
    
    Node *npubl = nclas->next_sibling->next_sibling;
    [data setValue: [self get_spilt_data:npubl] forKey:@"publisher"];
    
    Node *ncom = npubl->next_sibling->next_sibling;
    NSArray *com = [self get_spilt_data:ncom];
    [data setValue: com forKey:@"composer"];
    [data setValue: com forKey:@"artist"];
    
    Node *narr = ncom->next_sibling->next_sibling;
    if (narr == NULL){
//        [data setValue: @"" forKey:@"arranger"];
        return;
    }else{
        [data setValue: [self get_spilt_data:narr] forKey:@"arranger"];
    }

    Node *nper = narr->next_sibling->next_sibling;
    if (nper == NULL){
//        [data setValue: @"" forKey:@"performer"];
    }else{
        [data setValue: [self get_spilt_data:nper] forKey:@"performer"];
    }

}
 
- (void) storeStats:(const tree<htmlcxx::HTML::Node>&)dom
               forHtml:(const std::string&)html
                    in:(NSDictionary*)data
{
    Selector s(dom);
    Selector stats = s.select("td#rightcolumn div.smallfont");
//    cout << stats.size()<< "\n";
    
//    Selector rc = s.select("td#rightcolumn");
//    cout << rc.size() << "\n";
//    Node *nrc = *rc.begin();
//    Node *nn = nrc->first_child;
//    [self printNode:nrc->parent inHtml:_html];
    
    Node *nstats = *stats.begin();
    
    if (!nstats) return;
    
    Node *nrat = nstats->first_child->next_sibling;
    string _rat = nrat->last_child->prev_sibling->first_child-> data.text();
    [data setValue:[NSString stringWithCppStringTrimmed:&_rat] forKey:@"rating"];
    
    
    Node *ncoll = nrat->next_sibling->next_sibling;
    
    Node *nwish = ncoll->next_sibling->next_sibling;
    
    Node *ngenre = nwish->next_sibling->next_sibling;
    string _genre = ngenre->last_child->data.text();
    NSArray *genres = @[[NSString stringWithCppStringTrimmed:&_genre]];
    if ([genres count] ==1 && [genres[0] isMatchedByRegex:@".+,.+"]){
        genres = [self spiltMutiMetadataString:genres[0]];
    }
    [data setValue:genres forKey:@"genre"];
    [data setValue:genres forKey:@"category"];
    
    Node *nprod = ngenre->next_sibling->next_sibling;
    NSMutableArray *prods = [NSMutableArray new];
    Node *current = nprod->first_child;
    while (current) {
        if ( current->data.tagName().compare("a") ==0){
            [prods addObject:[self splitLanguagesInNodes: current->first_child]];
        }
        else if(!current->data.isTag()){
            string s = current->data.text();
            NSString *prod = [NSString stringWithCppStringTrimmed:&s];
            if ([prod hasVaildData]){
                [prods addObject:@{@"english": prod}];
            }
        }
        
        current = current->next_sibling;
    }
    if ([prods count] == 1){
        if ([prods[0] count] == 1){
            NSString *s = prods[0][@"english"];
            if (s && [s isMatchedByRegex:@".+,.+"]){
                NSMutableArray *prods2 =  [NSMutableArray new];
                NSArray *split = [self spiltMutiMetadataString:s];
                for (NSString *prod in split) {
                    [prods2 addObject:@{@"english": prod}];
                }
                prods = prods2;
            }
            
        }
    }
    
    [data setValue:prods forKey:@"products"];
    
    Node *nplat = nprod->next_sibling->next_sibling;
    if (nplat->last_child){
        string _plat = nplat->last_child->data.text();
        NSString *plat = [NSString stringWithCppStringTrimmed:&_plat];
        [data setValue:[self spiltMutiMetadataString:plat] forKey:@"platforms"];
    }
}

- (NSArray*)get_spilt_data:(Node *)n
{
    NSMutableArray *arr = [NSMutableArray new];
    Node *current = n->last_child->first_child;
    
    while (current) {
        if (!current) {
            current = current->next_sibling;
            continue;
        }else if (!current->data.isTag()){
            string _text = current->data.text();
            NSString *text = [NSString stringWithCppStringTrimmed:&_text];
            if ([text hasVaildData]){
                NSString *result = [text stringByReplacingOccurrencesOfRegex:@", *" withString:@""];
                
                for (NSString *s in [text componentsSeparatedByRegex:@"[,]"]){
                    NSString *ss = [s trimWhiteSpace];
                    if ([ss hasVaildData] && ![ss isMatchedByRegex:@"^\\("]){
                        [arr addObject:@{ @"english" : ss }];
                    }
                }
                
                if (![result isMatchedByRegex:@"^\\("]){
                    current = current->next_sibling;
                    continue;
                }
            }
        }
        
        if (!current->next_sibling) { // Only Text
            Node *m = current;
            while (m->data.isTag()) {
                m = m ->first_child;
            }
            string _text = m->data.text();
            NSString *text = [NSString stringWithCppStringTrimmed:&_text];
            if ([text hasVaildData]){
                [arr addObject:@{ @"english" : text }];
            }
        }else{
            Node *first_lang = current->first_child;
            NSDictionary *results = [self splitLanguagesInNodes:first_lang];
            if ([results count] != 0){
                [arr addObject:results];
            }
        }
        current = current->next_sibling;
    }
    return arr;
  
        
    
};

#pragma mark -
#pragma mark Tracks Array

- (NSArray*)getTracksArray:(NSDictionary*)data
{
    return [[data[@"tracks"] allValues] sortedArrayUsingComparator:
     ^NSComparisonResult(NSDictionary *x, NSDictionary *y) {
         NSComparisonResult res;
         res = [[x valueForKey:@"disc"] compare:[y valueForKey:@"disc"]];
         if (res == NSOrderedSame){
             res = [[x valueForKey:@"track"] compare:[y valueForKey:@"track"]];
         }
         if (res == NSOrderedSame){
             res = [[x valueForKey:@"length"] compare:[y valueForKey:@"length"]];
         }
         return res;
    }];
    
}

#pragma mark -
#pragma mark Common

- (NSString*)textFromNode:(Node*)n
{
    Node *current = n;
    while(current->first_child){
        current=current->first_child;
    }
    
    string _text = current->data.text();
    NSString *text = [NSString stringWithCppStringTrimmed:&_text];
    return text;
}

// String multiple values in a string into an array.
- (NSArray*) spiltMutiMetadataString:(NSString *)metadata
{
    if (!metadata) return nil;
    NSArray *arr = [metadata componentsSeparatedByRegex:@"[,] ?"];
    if ([arr count] != 0){
        return arr;
    }else{
        return @[[metadata trimWhiteSpace]];
    }
}

- (NSDictionary*)splitLanguagesInNodes:(Node*)node
{
    NSMutableDictionary *titles= [NSMutableDictionary new];
    while (node) {
        // for text only node
        if (!node->data.isTag()){
            string _title = node->data.text();
            NSString *title = [NSString stringWithCppStringTrimmed:&_title];
            if([title hasVaildData]){
                [titles setValue:[title stringByDecodingXMLEntities] forKey:@"english"];
                node = node->next_sibling;
                continue;
            }
        }
        
        node->data.parseAttributes();
        map<string, string> att= node->data.attributes();
//        cout << att.size();
        map<string, string>::iterator itLang= att.find("lang");
        
        NSString *lang;
        if (att.end() != itLang){
            string _lang  = itLang->second;
            lang = [[NSString alloc] initWithCppString:&_lang];
            lang = [namesMap valueForKey:lang];
        }else{
            lang = @"english";
        }
        
        if (node->first_child){
            Node *titleNode = node->first_child;
//            cout << "DDD";
//            cout << titleNode->data;
//            cout << titleNode->data.isTag();
//            cout << "ddd";
//            int a = titleNode->data.isTag();
            while(titleNode->data.isTag()){
                if (!titleNode->next_sibling){
                    titleNode = titleNode->first_child;
                }else{
                    titleNode = titleNode->next_sibling;
                }
                if (!titleNode)
                    break;
            }
            
            if (titleNode){
                string _title = titleNode->data.text();
                NSString *title = [[NSString alloc] initWithCppString:&_title];
                if ([title hasVaildData]){
                    [titles setValue: [title stringByDecodingXMLEntities] forKey:lang];
                }
            }
            
        }
        
        node = node->next_sibling;
    }
    return titles;
}

#pragma mark -
#pragma mark Html helpers  

- (void)printNode:(Node*)node
           inHtml:(std::string)html
{
    cout << html.substr(node->data.offset(), node->data.length()) << "\n\n\n";
}

- (std::string*) cppstringWithContentsOfURL:(NSURL*)url
                                     error:(NSError**)err
                                    encoding:(NSStringEncoding)encoding
{
    NSString *_html =  [NSString stringWithContentsOfURL: url
                                               encoding:NSUTF8StringEncoding
                                                  error:err];
    if (!_html){
        *err = nil;
        DDLogVerbose(@"%@ url is Not UTF8", url);
        if (encoding != NSUTF8StringEncoding){
            _html =  [NSString stringWithContentsOfURL: url
                                              encoding:encoding
                                                 error:err];
        }
        
        if (!_html){
            _html = [NSString stringWithContentsOfURLCleaned:url
                                                       error:err];
        }
    }
    
    if (!(*err)){
        return new string([_html UTF8String]);
    }
    return NULL;
}

@end
