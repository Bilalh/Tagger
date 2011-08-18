TODO
====

FIXME
-----

* Bug in mp3 files when *replacing* (not adding) artwork on files who album art has *never* been edited in iTunes, means the file can't be added to iTunes.
* Bug in mp4 files converted from flac using apps such XLD, when setting artwork, means the file can not be added to itunes.

* Don't allways use jpeg as the mine type. (needed for quicklook).
* mp3 images sometimes don't work in quicklook but always work in the app and itunes.


Filenames
---------
* Better message when names clash.

GUI
---
* Disable the menu back forword button when they can not be used instead of doing nothing.

Images
-------
* find image metadata.
  * 1200x1200, 200 KB (JPEG)

Renaming
--------
* tags from filename.

VGMDB
-----
* Taggings when tracks missing (done, but can tag wrong).
* Some kind of error handing when vgmdb returns no tracks.
* Selected catlog when there are multiple printings.


Later
-----
* Add flac (should be easy).
* Disallow the user from changing the preferences tab very quickly.
* Butons with icons for capitalization, labelsing and renaming.
* Icon for cover preferences. 
* Adds another autotag e.g disc cogs, freedb or musicbrainz.

----
Done
----
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