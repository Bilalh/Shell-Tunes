Shell Tunes {#readmeTitle}
===========
Control itunes from the command line, over **40** commands inculding play/pause, mute/unmute, playlist and play random album. Also inculdes also scripts for getting data from itunes.
{#description}

Usage
-----
Usage: `itunes.sh <option>`

Prerequisites
-------------
* Mac OS X (tested on 10.6)


Install 
-------
* Put the scripts in your `$PATH`
* alias for easy use e.g.  add `alias i='itunes.sh'` to your .bashrc

Options
-------
	Usage: itunes.sh <option>
	Options: (short)
	 (s) status          : Shows iTunes' status, and track info
	 (y) play            : Start playing.
	 (a) pause           : Pause iTunes.
	 (p) playpause       : Start playing / Pauses.

	 (n) next            : Go to the next track.
	 (b) prev            : Go to the previous track.
	 (r) rewind          : Rewinds the current track.

	 (m)                 : Toggles Mute iTunes' volume.
	     mute            : Mute iTunes' volume.
	     unmute          : Unmute iTunes' volume.
	 (v) vol up          : Increase iTunes' volume by 10%
	 (v) vol down        : Increase iTunes' volume by 10%
	 (v) vol #           : Set iTunes' volume to # [0-100]

	 (@) search        {string} : Search for songs in each field (results playlist must exist)
	 (@) search [type] {string} : Search for songs by type
	                            : Types are album, artist, composer 
	                            : comment, genre, grouping, name and year 
	 ($)               {string} : Serching for songs using name, album and comment as fields

	 (l) playlist        : List all the playlists
	 (l) playlist {name} : Plays the specified playlist 
	 (c) current         : List the songs of the current playlist

	 (d) random          : Plays a random album
	 (f) shuffle         : Toggles shuffle
	 (f) shuffle on      : Turns shuffle on
	 (f) shuffle off     : Turns shuffle off

	 (e) repeat all      : Set repeat to all
	 (e) repeat one      : Set repeat to on
	 (e) repeat off      : Set repeat to off


	     [0-5] {force}  : Set the current song rating
	 (6) 4.5   {force}  : Set the current song rating to 4½ stars

	 (t) stop           : Stop iTunes.
	 (q) quit           : Quit iTunes.


Bash Completion 
--------------
* Add this to your `.bash_profile` or `.bashrc`

		function i(){
			itunes.sh "$@"
		}

		function _ilist(){
			itunes.sh commands
		}

		function _icomp(){
			local curw
			COMPREPLY=()
			curw=${COMP_WORDS[COMP_CWORD]}
			COMPREPLY=($(compgen -W '`_ilist`' -- $curw))
			return 0
		}

		#  Completion for itunes.sh
		shopt -s progcomp
		complete -F _icomp i
		

Other
-----
* The extra folder contain extra scripts for controlling iTunes see the scripts for details.
* These scripts were moved from https://github.com/Bilalh/Scripts

Issues
------
None Yet

Licence
-------
[Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/ "Full details")

Authors
-------
* Bilal Hussain