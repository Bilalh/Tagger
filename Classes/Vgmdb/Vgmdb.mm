//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import "Vgmdb.h"
#import "Logging.h"

#import "NSString+Convert.h"

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
        NSLog(@"ddd");
        [self searchResults:@"Rorona"];
        
    }
    return self;
}

+ (void)initialize
{
    
    namesMap = [NSDictionary dictionaryWithObjectsAndKeys:
                @"@english",@"en",
                nil];
}

#pragma mark -
#pragma mark searching 

- (NSDictionary*) searchResults:(NSString*)search
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
    
//        map<string, string> att= b.attributes();
//        cout << att["url"];
//        cout << att["album"];
//        cout << att.size() ;
        
//        
//        std::map<std::string, std::string>::iterator i = att.begin();
//        for( ; i != att.end(); ++i )
//        {
//            cout << i->first << " -> " << i->second << endl;
//            
//        }
        
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        Selector res = s.select("div#albumresults tbody > tr");
        Selector::iterator it = res.begin();    
        cout << "Selector num:" << res.size() << "\n";
        
        for (; it != res.end(); ++it) {
            
//            [self printNode:*it inHtml:html];
            
            Node *catalog_td = (*it)->first_child;
            string catalog = catalog_td->first_child->first_child->data.text();
            
            Node *title_td = catalog_td->next_sibling->next_sibling;
            Node *first_title = title_td->first_child->first_child;
            [self splitLanguagesInNodes:first_title];
            
            Node *year_td = title_td->next_sibling;
            string year = year_td->first_child->first_child->data.text();
            
//           map<string, string> att= a.first_child->data.attributes();
//            cout << att.size();
            
        }
        
    }else {
        DDLogInfo(@"%@", [err localizedFailureReason]);
        
    }
    
    return [NSDictionary new];
}

#pragma mark -
#pragma mark vgmdb common

- (NSDictionary*)splitLanguagesInNodes:(Node*)node
{
    NSMutableDictionary *d = [NSMutableDictionary new];
    while (node) {
        string title = node->first_child->data.text();
        
        node->data.parseAttributes();
        map<string, string> att= node->data.attributes();
        cout << att.size();
        //TODO check for nothing?
        string _lang  = att["lang"];
        NSString *lang = [namesMap objectForKey:
                          [[NSString alloc] initWithCppString:&_lang] ];
        node = node->next_sibling;
    }
    return d;
}

#pragma mark -
#pragma mark Html helpers  

- (void)printNode:(Node*)node
          inHtml:(std::string)html
{
    std::cout << html.substr(node->data.offset(), node->data.length()) << "\n\n\n";
}


@end
