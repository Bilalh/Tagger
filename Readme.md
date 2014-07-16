Tagger {#readmeTitle}
=====
Tagger is application that auto tags audio files. It also supports batch tag editing See the [website](http://bilalh.github.com/projects/tagger/ "details") for more  details 
{#description}

Prerequisites
-------------
* Only tested on the latest Mac OSX 10.8 release, should work on 10.7.  Untested on 10.9
* 64 bit only

Install From Source
-------------------
### Prerequisites
* Only tested on the latest Mac OSX 10.8 release, should work on 10.7. Untested on 10.9
* 64 bit only

### Introductions
* need taglib headers  e.g with homebrew
  `brew install taglib`

Build the release version of Tagger.

Issues
------
* To report issues go to the [issues tracker](https://github.com/Bilalh/Tagger/issues "Issues") on Github

* Bug in mp3 files sometimes when *replacing* (not adding) artwork on files who album art has *never* been edited in iTunes, means the file can't be added to iTunes. This happens sometimes happens after replacing the artwork twice (when using vbr files).

*Work around*
To replace a mp3 cover art a second time use `refresh`(⌘R) then `Parent Folder`(⌘↑) then `Back`(⌘\[) menus items then replace the cover.

* If you did not follow the advice use `mp3val -f name.mp3` to fix the mp3 with the tags intact, see 
[this blog post](http://bilalh.github.com/2011/12/24/fixing-corrupt-mp3s/ "Fixing corrupt mp3s"). 

* Bug in malformed m4a files sometimes when *replacing* (not adding) artwork, means the file can't be played in iTunes.

* Quit Tagger before adding m4a (happen mostly with lossless m4a's and when 'Copy files to iTunes Media Folder' is unchecked in iTunes) to iTunes that were edited in Tagger, otherwise the metadata does not change. If you  added the mp4 before Tagger was quit, remove them from iTunes and add them again.

Information
----------
* Writes 2.4 id3 tags.

Libraries Used
--------------
* TagLib
* BWHyperlinkButtonCell from BWToolKit
* CCTColorLabelMenuItemView
* Lumberjack
* MASPreferencesViewController
* RegexkitLite
* hcxslect

Licence
-------
[Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/ "Full details")

Authors
-------
* Bilal Syed Hussain
