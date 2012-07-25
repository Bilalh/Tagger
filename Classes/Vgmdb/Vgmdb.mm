//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import "Vgmdb.h"

#import "NSString+Convert.h"

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

@interface Vgmdb()

- (void)printNode:(Node*)node
          inHtml:(std::string)html;


- (NSDictionary*)splitLanguagesInNodes:(Node*)node;

@end


@implementation Vgmdb

#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    if (self) {
        DDLogVerbose(@"ddd");
//        [self searchResults:@"Rorona"];
        
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
#pragma mark searching 

- (NSArray*) searchResults:(NSString*)search
{
    
    
    NSString *baseUrl = @"http://vgmdb.net/search?q=";
    
    NSString *tmp = [baseUrl stringByAppendingString:search];
    NSString *_url = [tmp stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    NSURL *url = [NSURL URLWithString:_url];
    
    NSError *err = nil;
    NSString *_html = [NSString stringWithContentsOfURL: url
                                               encoding:NSISOLatin1StringEncoding
                                                  error:&err];
    
    if (!err){
        string html  = std::string([_html UTF8String]);
        
        htmlcxx::HTML::ParserDom parser;
        tree<htmlcxx::HTML::Node> dom = parser.parseTree(html);
        Selector s(dom);
            
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        Selector res = s.select("div#albumresults tbody > tr");
        cout << "Selector num:" << res.size() << "\n";
        
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
            string _year = year_td->first_child->first_child->data.text();
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
#pragma mark vgmdb common

- (NSDictionary*)splitLanguagesInNodes:(Node*)node
{
    NSMutableDictionary *titles= [NSMutableDictionary new];
    while (node) {
        
        node->data.parseAttributes();
        map<string, string> att= node->data.attributes();
        cout << att.size();
        map<string, string>::iterator itLang= att.find("lang");
        
        NSString *lang;
        if (att.end() != itLang){
            string _lang  = itLang->second;
            lang = [[NSString alloc] initWithCppString:&_lang];
            lang = [namesMap valueForKey:lang];
        }else{
            lang = @"@english";
        }
        
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
        node = node->next_sibling;
    }
    return titles;
}

#pragma mark -
#pragma mark Html helpers  

- (void)printNode:(Node*)node
          inHtml:(std::string)html
{
    std::cout << html.substr(node->data.offset(), node->data.length()) << "\n\n\n";
}


@end
