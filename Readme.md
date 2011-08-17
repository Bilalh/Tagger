Readme
======


Requiments
----------
* Mac OS X 10.6+
* Macruby 0.10+
* 64 bit only

Install From Source
-------------------
Build the release version of VGTagger.

(When embeding make sure require 'rubygems'  is commented with a # before it)

Run Embed MacRuby on it which does the follows to embed the MacRuby framework

	macruby_deploy --compile --embed --gem nokogiri --gem htmlentities --verbose

To save 15mb you can replace 
  VGTagger.app/Contents/Frameworks/MacRuby.framework/Versions/0.10/usr/lib/ruby/1.9.2
with 1.9.2 at the root of the project


Libraries Used
--------------
* MacRuby
* TagLib 
*
* BWHyperlinkButtonCell from BWToolKit
* CCTColorLabelMenuItemView
* Lumberjack
* MASPreferencesViewController

Issues
------
* Bug in mp3 when replacing artwork on files who album art has *never* been edited in iTunes.
* Bug in mp4 files when  replacing artwork on files who album art has *never* been edited in iTunes.