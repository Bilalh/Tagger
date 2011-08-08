Changelog
=========

------------
Version 0.14
------------
### Features ###
* Added a button for searching vgmdb.
* Display the result if there is only one result from the search
* Back/forward Reveal disable when not usable instead of doing nothing

### Bug fixes ###
* Fixed a bug when vgmdb returns no results.

------------
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


------------
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

------------
Version 0.11 (Tue Aug 02 2011 03:21:21 +0100)
------------
* Better error handing. 
* Allows batch renaming of files based on tags.
* Gui for batch renaming of files based on tags.


------------
Version 0.10 (Sun Jul 31 2011 04:51:54 +0100)
------------
* Made comments tag iTunes compatible.
* Muti-row editing.
* Some bug fixes.


-----------
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


-----------
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


-----------
Version 0.7 (Fri Jul 22 2011 20:06:13 +0100)
-----------
* Complete mp4 tag read/write support.
* File browser with previous and forward buttons.
	* Allows user specified directory with a open dialog. 
	* Allows going to parent directories easily.  


--------------
Older Versions
--------------
* Allow editing of data directory in the table view
* Able to search for albums on vgmdb and get the data for that album.
	* Using a gui.
	* Allows searching three languages English, Romaji and Kanji.
* Menu items for to Uppercase ^U, to Lowercase Shift ^U, Capitalise Command ^U
* GUI
* Classes 

