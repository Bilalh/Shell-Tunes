#!/usr/bin/env osascript
-- Bilal Hussain 
-- Gets the filepaths of all the files in the album.
on run argv
	set albumName to item 1 of argv as string
	tell application "iTunes"
		set selected_songs to ""
		set searchResults to file tracks whose album is albumName 
		repeat with aTrack in searchResults
			if selected_songs is not equal to "" then
				set selected_songs to selected_songs & "\n"
			end if
			try
				set selected_songs to selected_songs & (quoted form of POSIX path of (get aTrack's location))
			on error
				contuine
			end try
		end repeat
	end tell	
	if selected_songs is not "" then
		selected_songs as string
	end if
	
end run