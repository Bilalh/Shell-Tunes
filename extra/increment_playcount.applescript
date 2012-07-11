#!/usr/bin/env osascript
on run argv
	
	set theAlbum to item 1 of argv
	set theTrackNum to item 2 of argv
	set theDiskNum to item 3 of argv
	
	--set theAlbum to "Dragon Quest I~IX ~Scene-Separated~ Symphonic Suite"
	--set theTrackNum to 1 as integer
	--set theDiskNum to 1 as integer
	
	tell application "iTunes"
		set aTrack to item 1 of (tracks of playlist "Music" whose album is equal to theAlbum Â
			and track number is equal to theTrackNum Â
			and disc number is equal to theDiskNum)
		set aTrack's played count to (aTrack's played count) + 1
		
	end tell
end run