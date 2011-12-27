Tagger {#readmeTitle}
=====
Tagger is application that auto tags audio files. It also supports batch tag editing See the [website](http://bilalh.github.com/projects/tagger/ "details") for more  details 
{#description}

Prerequisites
-------------
* Mac OS X 10.6+
* 64 bit only

Install From Source
-------------------
### Prerequisites
* Mac OS X 10.6+
* Macruby 0.10+
* 64 bit only

### Introductions
Build the release version of VGTagger.

(When embedding make sure `require 'rubygems'` in `Vgmdb.rb`  is commented with a # before it)

Run Embed MacRuby on it which does the follows to embed the MacRuby framework

	macruby_deploy --compile --embed --gem nokogiri --gem htmlentities --verbose

To save 15mb you can remove the unused .rb files in		
  `VGTagger.app/Contents/Frameworks/MacRuby.framework/Versions/0.10/usr/lib/ruby/1.9.2`


Issues
------
* Bug in mp3 files sometimes when *replacing* (not adding) artwork on files who album art has *never* been edited in iTunes, means the file can't be added to iTunes. This happens sometimes happens after replacing the arkwork twice (when using vbr files).

*Work around*
To replace a mp3 cover art a second time use `refresh`(⌘R) then `Parent Folder`(⌘↑) then `Back`(⌘\[) menus items then replace the cover.

* If you did not follow the advice use `mp3val -f name.mp3` to fix the mp3 with the tags intact, see 
[this blog post](http://bilalh.github.com/2011/12/24/fixing-corrupt-mp3s/ "Fixing corrupt mp3s"). 

* Bug in malformed m4a files sometimes when *replacing* (not adding) artwork, means the file can't be played in iTunes.


Libraries Used
--------------
* MacRuby
* TagLib  

* BWHyperlinkButtonCell from BWToolKit
* CCTColorLabelMenuItemView
* Lumberjack
* MASPreferencesViewController
* RegexkitLite

Licence
-------
[Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/ "Full details")

Authors
-------
* Bilal Hussain