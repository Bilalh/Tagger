//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import "Vgmdb.h"
#import "Vgmdb+private.h"

#import "NSString+Convert.h"
#import "RegexKitLite.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);

#include <string>
#include <iostream>
#include <set>

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
                @"@english", @"en",
                @"@kanji",   @"ja",
                @"@romaji",  @"ja-Latn",
                @"@english", @"English",
                @"@kanji",   @"Japanese ",
                @"@romaji",  @"Romaji",
                @"latin",    @"",
                nil];
}

#pragma mark -
#pragma mark Searching 

- (NSArray*) searchResults:(NSString*)search
{
    NSString *baseUrl = @"http://vgmdb.net/search?q=";
    NSString *tmp = [baseUrl stringByAppendingString:search];
    NSString *_url = [tmp stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    NSError *err = nil;
    string *html  = [self cppstringWithContentsOfURL:[NSURL URLWithString:_url]
                                              error:&err];
    
    if (!err){
        htmlcxx::HTML::ParserDom parser;
        tree<htmlcxx::HTML::Node> dom = parser.parseTree(*html);
        Selector s(dom);
        
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        Selector res = s.select("div#albumresults tbody > tr");
//        cout << "Selector num:" << res.size() << "\n";
        
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
        
        return rows; 
        
    }else {
        DDLogInfo(@"%@", [err localizedFailureReason]);
    }
    
    return [NSArray new];
}

#pragma mark -
#pragma mark Album data

// 
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

- (Node*) getNodeFrom:(std::string) selector
        usingSelector:(Selector) s
{
    Selector res = s.select("h1>span.albumtitle");
    Node *n = *res.begin();
    return n;
}


string _html;

- (void) storeMetadata:(const tree<htmlcxx::HTML::Node>&)dom
               forHtml:(const std::string&)html
                in:(NSDictionary*)data
{

    _html = html;
    Selector s(dom);
    Selector meta = s.select("table#album_infobit_large");
    
    /* Catalog */
    Selector catalogElem = meta.select("tr td[width='100%']");
    Node *ncat = *catalogElem.begin();
    
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
    NSArray *pubs = @[pub];
    
    [data setValue:pubs forKey:@"publishedFormat"];
    
    Node *nprice = npub->next_sibling->next_sibling;
    [data setValue:get_data(nprice) forKey:@"price"];

    Node *nfor = nprice->next_sibling->next_sibling;
    [data setValue:get_data(nfor) forKey:@"mediaFormat"];
    
    Node *nclas = nfor->next_sibling->next_sibling;
    NSString *clas = get_data(nclas);
    if (clas){
        NSArray *arr = [clas componentsSeparatedByRegex:@"[&,(){}.-\\~] ?"];
        if ([arr count] != 0){
            [data setValue:arr forKey:@"classification"];
        }else{
            [data setValue:@[[clas trimWhiteSpace]] forKey:@"classification"];
        }

    }
    
    Node *npubl = nclas->next_sibling->next_sibling;
    [data setValue: [self get_spilt_data:npubl] forKey:@"publisher"];
    
    Node *ncom = npubl->next_sibling->next_sibling;
    NSArray *com = [self get_spilt_data:ncom];
    [data setValue: com forKey:@"composer"];
    [data setValue: com forKey:@"artist"];
    
    Node *narr = ncom->next_sibling->next_sibling;
    [data setValue: [self get_spilt_data:narr] forKey:@"arranger"];
    
    Node *nper = narr->next_sibling->next_sibling;
    [data setValue: [self get_spilt_data:nper] forKey:@"performer"];
    
    Selector stats = s.select(" td#rightcolumn  div.smallfont ");
    
    Node *nstats = *stats.begin();
    
    Node *nrat = nstats->first_child->next_sibling;
    string _rat = nrat->last_child->prev_sibling->first_child-> data.text();
    [data setValue:[NSString stringWithCppStringTrimmed:&_rat] forKey:@"rating"];
    
    
    Node *ncoll = nrat->next_sibling->next_sibling;
    
    Node *nwish = ncoll->next_sibling->next_sibling;

    Node *ngenre = nwish->next_sibling->next_sibling;
    string _genre = ngenre->last_child->data.text();
    NSArray *genres = @[[NSString stringWithCppStringTrimmed:&_genre]];
    [data setValue:genres forKey:@"genre"];
    [data setValue:genres forKey:@"category"];
    
    Node *nprod = ngenre->next_sibling->next_sibling;
    NSDictionary *prod =[self splitLanguagesInNodes: nprod->last_child->prev_sibling->first_child];
    [data setValue:@[prod] forKey:@"products"];
    
    Node *nplat = nprod->next_sibling->next_sibling;
    string _plat = nplat->last_child->data.text();
    NSArray *plats = @[
        [NSString stringWithCppStringTrimmed:&_plat]
    ];
    [data setValue:plats forKey:@"platforms"];
    
}
 
- (NSArray*)get_spilt_data:(Node *)n
{
    NSMutableArray *arr = [NSMutableArray new];
    Node *current = n->last_child->first_child;
    
    while (current) {
        if (!current) {
            current = current->next_sibling;
            continue;
        }
        
        if (!current->next_sibling) { // Only Text
            Node *m = current;
            while (m->data.isTag()) {
                m = m ->first_child;
            }
            string _text = m->data.text();
            NSString *text = [NSString stringWithCppStringTrimmed:&_text];
            if ([text length] >0 && ![text isMatchedByRegex:@"^[,.()\\~ - \"'\\[\\]:!@]+$"]){
                [arr addObject:@{ @"@english" : text }];
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


- (NSDictionary*)getAlbumData:(NSURL*) url
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    NSError *err;
    string *html = [self cppstringWithContentsOfURL:url error:&err];
    
    if (html == NULL){
        NSLog(@"Error %@", [err localizedDescription]);
        return data;
    }
    
    htmlcxx::HTML::ParserDom parser;
    tree<htmlcxx::HTML::Node> dom = parser.parseTree(*html);
    Selector s(dom);
    
    [data setValue:[self getAlbumTitles:dom forHtml:*html]
            forKey:@"album"];
    
    [self storeMetadata:dom forHtml:*html in:data];
    
    [data setValue:url forKey:@"url"];
    return data;
}


#pragma mark -
#pragma mark Common

- (NSDictionary*)splitLanguagesInNodes:(Node*)node
{
    NSMutableDictionary *titles= [NSMutableDictionary new];
    while (node) {
        
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
            lang = @"@english";
        }
        
        if (node->first_child){
            Node *titleNode = node->first_child;
            while(titleNode->data.isTag()){
                if (!titleNode->next_sibling){
                    titleNode = titleNode->first_child;
                }else{
                    titleNode = titleNode->next_sibling;
                }
            }
            
            string _title = titleNode->data.text();
            NSString *title = [[NSString alloc] initWithCppString:&_title];
            
            [titles setValue: title forKey:lang];
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
                                     error:(NSError**)error
{
    NSString *_html = [NSString stringWithContentsOfURL: url
                                               encoding:NSUTF8StringEncoding
                                                  error:error];
    if (!(*error)){
        return new string([_html UTF8String]);
    }
    return NULL;
}

@end
