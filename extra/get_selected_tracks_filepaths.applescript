#!/usr/bin/env osascript
# Bilal Hussain
# Returns the file paths of teh selected tracks

tell application "System Events"
	if (get name of every process) contains "iTunes" then set okflag to true
end tell
if okflag then
	tell application "iTunes"
		
		if selection is {} then 
			""
		else
			set selected_songs to ""
			repeat with this_track in selection
				if selected_songs is not equal to "" then
					set selected_songs to selected_songs & "\n"
				end if
				try
					set selected_songs to selected_songs & (quoted form of POSIX path of (get this_track's location))
				on error
					contuine
				end try
			end repeat
			
			if selected_songs is not "" then
				selected_songs as string
			end if
		end if
	end tell
end if