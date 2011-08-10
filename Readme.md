Readme
======


-------
Install
-------
Build the release version of VGTagger.

Run Embed MacRuby on it which does the follows to embed the MacRuby framework

	macruby_deploy --compile --embed --verbose --gem nokogiri

To save 15mb you can replace 
  VGTagger.app/Contents/Frameworks/MacRuby.framework/Versions/0.10/usr/lib/ruby/1.9.2
with 1.9.2 at the root of the project

--------------
Libraries Used
--------------
* MacRuby
* TagLib 
* BWHyperlinkButtonCell from BWToolKit
* Lumberjack
* MASPreferencesViewController
