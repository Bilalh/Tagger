//
//  Vgmdb+private.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 28/07/2012.
//  Copyright (c) 2012 St. Andrews KY16 9XW. All rights reserved.
//

#import "Vgmdb.h"

#include <string>
#include <iostream>
#include <set>

#include <htmlcxx/html/ParserDom.h>

#include "hcxselect.h"

@interface Vgmdb (_private)

- (void)printNode:(hcxselect::Node*)node
           inHtml:(std::string)html;


- (NSDictionary*)splitLanguagesInNodes:(hcxselect::Node*)node;

- (std::string*) cppstringWithContentsOfURL:(NSURL*)url
 error:(NSError**)error;

- (NSDictionary*) getAlbumTitles:(const tree<htmlcxx::HTML::Node>&)dom
                         forHtml:(const std::string&)html;

- (void) storeMetadata:(const tree<htmlcxx::HTML::Node>&)dom
               forHtml:(const std::string&)html
                    in:(NSDictionary*)data;

- (NSDictionary*)getAlbumData:(NSURL*) url;


@end
