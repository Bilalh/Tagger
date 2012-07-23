//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import "Vgmdb.h"
#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);

#include <string>
#include <iostream>
#include <set>

#include <htmlcxx/html/ParserDom.h>

#include "hcxselect.h"
#include "VgmdbStruct.h"

using namespace std;
using namespace hcxselect;

@interface Vgmdb()

- (void)printNode:(Node*)node
          inHtml:(std::string)html;

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
        cout << res.size() << "\n";
        
        for (; it != res.end(); ++it) {
            
            [self printNode:*it inHtml:html];
            
            Node *catalog_td = (*it)->first_child;
            string catalog = catalog_td->first_child->first_child->data.text();
            
            Node *title_td = catalog_td->next_sibling->next_sibling;
            
            Node *year_td = title_td->next_sibling;
            
//           map<string, string> att= a.first_child->data.attributes();
//            cout << att.size();
            
        }
        
    }else {
        DDLogInfo(@"%@", [err localizedFailureReason]);
        
    }
    
    return [NSDictionary new];
}

- (void)printNode:(Node*)node
          inHtml:(std::string)html
{
    std::cout << html.substr(node->data.offset(), node->data.length()) << "\n\n\n";
}


@end
