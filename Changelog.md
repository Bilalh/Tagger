Changelog
=========


Version 1.4
-------------
### Features ###
* Results can be sorted when searching.
* Tooltips.
* Files can be dragged to the table.
* Added Latin as language since some soundtracks tracks are in [Latin](http://vgmdb.net/album/26335 "Puella Magi Madoka Magica Special CD 2 Original Soundtrack I").
* Arranges multiple catalog number nicely.
* Tags From Files (works like renames with tags).  
 	With error handing.  
 	and menus with predefined options.
* Rows in main table can be rearranged.
* Menu item for auto-Renumbering of files.
* Can drag a row ontop of another to copy tags.
* Genre and Grouping preferences.

### Improvements ###
* Macruby loading.
* QuickLookTableView now works with delgate drag and drop now.
* Multiple values with ints.


### Bug Fixes ###
* Metadata to Comments newline.
* Url when going directly to the results.
* Refresh.
* Fixed a bug where the composer was tothe arranger.
* Made catlog field bigger since I found some rare long ids.
* Url when ending in a slash.
* Use jpeg when the user want jpeg instead of using png.
* Chooses the correct language if english is not there when auto tagging.
* Fixed a bug with extension checking (now uses filepath instead of display name).
* Fix nils when the album does not have a [platform](http://vgmdb.net/album/19776 "Neon Genesis Evangelion").
* Refreshing the table on renaming with custom format.
* Fixed a bug where copying tags from a mp3 to a m4a file.

Version 1.3 (Fri Aug 12 2011 16:19:09 +0100)
-----------
### Features ###
* Label colours for files shown.
* Nicer display of label colour for selected row.
* Right click menu that allows labeling files.
* Right click menu item reveal in finder.
* New 512x512 Icon 
* Can rid of unused code.
* When display search results, you can double click to go the albums webpage.

### Improvements ###
* Shows the label colour as a dot when selecting a labeled row.
* Can label multiple row at once.
* Does not show the of in disc 1 of 2 if there is total number of discs, same for tracks

### Bug Fixes ###
* When editing the data of a selected row.

Version 1.2 (Thu Aug 11 2011 03:34:20 +0100)
-----------
### Features ###
* When using using metadata to comments, the text aligns nicely in itunes.
* Allows going to the next/previous row using a keyboard (alt down/alt up).
* Updated to always show the selected row.  
* Export to Itunes menu option (alt cmd E).
* QuickLook support (allows playing of audio files).
* Shortcut cmd-Y.
* Allows multiple selection.
* Can use up down to go to next track
* Press space when on a selected track also does quicklook.
* Quicklook toolbar button.

### Improvements ###
* Disable Open Selected Fodler if the user has not selected a folder.
* Disable QuickLook if the user has not selected a file.

### Bug Fixes ###
* Cover comparing with NSMultipleValuesMarker

Version 1.1.6 (Wed Aug 10 2011 05:34:41 +0100)
-------------
### Features ###
* refreshes the table on auto tagging.
* Small size (15mb smaller).

Version 1.1.5 (Wed Aug 10 2011 03:41:38 +0100)
-------------
### Features ###
* Adds formats for renaming. e.g. 01 - title .
* Are stored in the plist for easy changing.
* Can click any where on a directory row to go do it.
* Can open a selected  directory with cmd-O.

### Bug fixes ###
* highlighting When clicking on a directory.

Version 1.1 (Wed Aug 10 2011 01:31:51 +0100)
-----------
### Features ###
* Images can not be dragged for directory.
* The cover art is now named 'title - cover' which allows 
multiple cover to be dragged to the desktop/
* Which can be changed in the prefs.

Version 1.0.1 (Tue Aug 09 2011 16:52:14 +0100)
-------------
### Features ###
* Debug statement do not appear in release version. 

### Bug fixes ###
* Fix a bug with the vgmdb menu item not been enable.

Version 1.0 (Tue Aug 09 2011 05:05:41 +0100)
-----------
### Features ###
* Added a button for searching vgmdb.
* Display the result if there is only one result from the search.
* Back/forward/Reveal/Vgmdb disable when not usable instead of doing nothing.
* Menu item and shortcut cmd-1 for going to the starting directory.
* Table columns sorting and highligting on all columns.
* Auto embed Macruby .
* Embed  tablib and fixed build settings.
* Table columns lengths
* Shows the results straight away if there only one when searching Vgmdb
* The cover art can be dragged to finder or any other place 
* Pref for how cover art is dragged

### Bug fixes ###
* Fixed a bug when vgmdb returns no results.

Version 0.13 (Sun Aug 07 2011 23:39:44 +0100)
------------
### Features ###
* Music files (m4a and mp3) can be dragged onto the dock icon to go the directory of the file.
* Can drag directory but now allows all files.
* Size column.
* Tags can now do bitrate channels sample rate and kind.
* FileSystemNode can now tell it size.
* Disc and track pairs.
* Prefs for hiding columns.
* Default values.
* Prefs for setting start directory.
* Allows using the current directory as the start directory.

### Bug fixes ###
* Fixed Warnings about missing method.
* Fixed a bug where no window was open.


Version 0.12 (Fri Aug 05 2011 02:23:54 +0100)
------------
### Features ###
* Pad the track number when renaming.
* Batch renaming using sub directories.
* Shortcuts for back and forword.
* Shortcuts for parent directory.
* Menu and shortcuts for common directories.
* Refresh menu item.
* Reveal in Finder menu item.
* Reopen menu item which opens the last open window.
* Shows that the selcted tracks have different values.

### Bug fixes ###
* Fixed a bug where selection was not consecutive.
* Fixed a bug with update data when changing directory.
* Field are now not editable when selecting a directory.
* Compares images properly which shows if the selected files has the same image.

Version 0.11 (Tue Aug 02 2011 03:21:21 +0100)
------------
### Features ###
* Better error handing. 
* Allows batch renaming of files based on tags.
* Gui for batch renaming of files based on tags.


Version 0.10 (Sun Jul 31 2011 04:51:54 +0100)
------------
### Features ###
* Made comments tag iTunes compatible.
* Muti-row editing.
* Some bug fixes.


Version 0.9 (Fri Jul 29 2011 15:05:00 +0100)
-----------
### Features ###
* The length of track can now be found using Tags.
* Auto tagging for tracks names is done
* Allows choosing the language.
* Auto tagging for other fields done.
* Allows choosing which fields to update.
* Show the url, which is clickable.
* Read and write of url tag.
* Allows saving of url of from auto tagger.
* Read/write mp3 cover art.
* Read/write mp4 cover art.

### Bug fixes ###
* Made length column uneditable since it should not be changed.


Version 0.8 (Mon Jul 25 2011 02:55:27 +0100)
-----------
### Features ###
* Complete mp3 (IDV tag read/write support.
* Allows clearing number fields e.g year.
* Validate number fields to allow only numbers. 
* Allows changes the language of each field in the results from vgmdb.
* Now allows search using the tags of the song to allow easier searching.

### Bug fixes ###
* Better error handing when vgmdb is missing data.
* Fixed a bug when trying to save a field with an empty string.


Version 0.7 (Fri Jul 22 2011 20:06:13 +0100)
-----------
### Features ###
* Complete mp4 tag read/write support.
* File browser with previous and forward buttons.
* Allows user specified directory with a open dialog. 
* Allows going to parent directories easily.  


Older Versions
--------------
### Features ###
* Allow editing of data directory in the table view
* Able to search for albums on vgmdb and get the data for that album.
* Using a gui.
* Allows searching three languages English, Romaji and Kanji.
* Menu items for to Uppercase ^U, to Lowercase Shift ^U, Capitalise Command ^U
* GUI
* Classes 

