TODO
====
* check swapFirstAndLastName

FIXME
-----

* Tests for
http://vgmdb.net/album/33474
http://vgmdb.net/album/22168
http://vgmdb.net/album/919

* Bug in mp3 files sometimes when *replacing* (not adding) artwork on files who album art has *never* been edited in iTunes, means the file can't be added to iTunes. This happens sometimes happens after replacing the all work twice.
	* **Work around**
	To replace a mp3 cover art a second time use `refresh`(⌘R) then `Parent Folder`(⌘↑) then `Back`(⌘\[) menus items then replace the cover.

Images
------
* Don't always use jpeg as the mine type. (needed for quicklook).
* mp3 images sometimes don't work in quicklook but always work in the app and itunes.


Filenames
---------
* Better error message when names clash.

GUI
---
* Disable the menu back forward button when they can not be used instead of doing nothing.

Images
-------
* find image metadata like:
  * 1200x1200, 200 KB (JPEG)


VGMDB
-----
* Taggings when tracks missing (done, but can tag wrong).
* Some kind of error handing when vgmdb returns no tracks.
* Select correct catalog printing when there are multiple printings.

Later
-----
* Disallow the user from changing the preferences tab very quickly.
* Butons with icons for capitalization, labelling and renaming.
* Icon for cover preferences. 
* Adds another autotager e.g discogs, freedb or musicbrainz.

----
Done
----
* Either find faster way to use it or rewrite Vgmdb in Objective C/C++
* Test on 10.7
* Reduce min size
* Allow muti row editing.
* Muti row selection can be non constive rows, handle this.
* Some means of showing that the values for selected rows are different.
* Better image equals method for NSImage (defualt just does pointer comparing).
* Defaults e.g path etc.
* Turn of the hard code values in vgmdb auto tagger.
* Disble buttons that can not be used.
* Table columns sorting.
* Auto embed macruby.
* Image dragging.
* Disable Open Selected Fodler if the user has not selected a folder. At the moment it does nothing if the user tries to do this.
* Added latin as a language.
* tags from filename.
* Sort by date sort by the string instead of date
* Go menu icons 
* Error message when invalid characters in filenames. 