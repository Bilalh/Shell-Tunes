#!/usr/bin/env osascript
# Bilal Hussain

# Gets the song data in the form 
-- Track : Fur Elise ★★★★★
-- Album : Für Elise
-- Artist: Beethoven
-- Time  : 0:01/3:92


tell application "iTunes"
	set res to " Track : " & (the name of current track as string) & " "
	set rate to (the rating of current track as string)
end tell
set res to res & make_stars(rate)
tell application "iTunes"
	set res to res & "
" & " Album : " & (the album of current track as string) & "
" & " Artist: " & (the artist of current track as string) & "
" & " Time  : "
end tell

set res to res & make_song_time()

on make_song_time()
	tell application "iTunes" to set tt to {player position} & {duration} of current track
	
	
	set cMin to (1st item of tt) div 60
	set cSec to (1st item of tt) mod 60
	set tMin to (2nd item of tt) div 60
	set tSec to (2nd item of tt) mod 60
	
	
	set cur to cMin & ":" & zero_pad(cSec, 2) & "/" & tMin & ":" & zero_pad(tSec, 2) as string
	return cur
end make_song_time

on zero_pad(value, string_length)
	set tmp_string to "000000000" & (value as string)
	set padded_value to characters ((length of tmp_string) - string_length + 1) thru -1 of tmp_string as string
	return padded_value
end zero_pad

on make_stars(rating)
	set ret to "" as Unicode text
	set stars to rating / 20
	set half to rating mod 20 = 10
	repeat with i from 1 to stars
		set ret to ret & "★"
	end repeat
	if half then set ret to ret & "½"
	return ret 
end make_stars