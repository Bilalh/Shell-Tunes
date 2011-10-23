#!/usr/bin/env osascript
-- Bilal Hussain 
property randomAlbumName : "Some Random Album"

tell application "iTunes"
	set myMusicLibrary to (some playlist whose special kind is Music)
	if exists (some user playlist whose name is randomAlbumName) then
		delete every track of playlist randomAlbumName
	else
		make new playlist with properties {name:randomAlbumName, shuffle:false}
	end if
	set new_playlist to playlist randomAlbumName

	tell myMusicLibrary
		set someTrack to some track
		set play_album to album of someTrack
		set disc_number to disc number of someTrack
		set total_album_tracks to tracks whose album is play_album and disc number is disc_number
		set spareTracks to {}
		repeat with n from 1 to length of total_album_tracks
			set chk to false
			repeat with a_track in total_album_tracks
				if track number of a_track is n then
					set chk to true
					try
						duplicate a_track to new_playlist
					end try
					exit repeat
				end if
			end repeat
			if chk is false then set end of spareTracks to a_track
			-- start playing after addition of first song
			try
				if n = 1 then play new_playlist
			end try
		end repeat
		if spareTracks is not {} then
			repeat with a_track in spareTracks
				duplicate a_track to new_playlist
			end repeat
		end if
	end tell
end tell