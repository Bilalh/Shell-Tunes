#!/bin/bash
# Bilal Hussain

# Controls Itunes from the command line
# no external dependencies 

usage () {
	echo "Usage: `basename "$0"` <option>";
	echo
	echo "Options: (short)";
	echo " (s) status          : Shows iTunes' status, and track info";
	echo " (y) play            : Start playing.";
	echo " (a) pause           : Pause iTunes.";
	echo " (p) playpause       : Start playing / Pauses.";
	echo                       
	echo " (n) next            : Go to the next track.";
	echo " (b) prev            : Go to the previous track.";
	echo " (r) rewind          : Rewinds the current track.";
	echo                       
	echo " (m)                 : Toggles Mute iTunes' volume.";
	echo "     mute            : Mute iTunes' volume.";
	echo "     unmute          : Unmute iTunes' volume.";
	echo " (v) vol up          : Increase iTunes' volume by 10%";
	echo " (v) vol down        : Increase iTunes' volume by 10%";
	echo " (v) vol #           : Set iTunes' volume to # [0-100]";
	echo                     
	echo " (@) search        {string} : Search for songs in each field (results playlist must exist)";
	echo " (@) search [type] {string} : Search for songs by type";
	echo "                            : Types are album, artist, composer ";
	echo "                            : comment, genre, grouping, name and year ";
	echo " ($)               {string} : Serching for songs using name, album and comment as fields";
	echo 
	echo " (l) playlist        : List all the playlists";
	echo " (l) playlist {name} : Plays the specified playlist ";
	echo " (c) current         : List the songs of the current playlist";
	echo
	echo " (d) random          : Plays a random album";
	echo " (f) shuffle         : Toggles shuffle";
	echo " (f) shuffle on      : Turns shuffle on";
	echo " (f) shuffle off     : Turns shuffle off";
	echo
	echo " (e) repeat all      : Set repeat to all";
	echo " (e) repeat one      : Set repeat to on";
	echo " (e) repeat off      : Set repeat to off";
	echo
	echo
	echo "     [0-5] {force}  : Set the current song rating" ;
	echo " (6) 4.5   {force}  : Set the current song rating to 4½ stars" ;
	echo                      
	echo " (t) stop           : Stop iTunes.";
	echo "     commands       : Lists commands (for bash completion) "
	echo " (q) quit           : Quit iTunes.";
}

# Returns the song's data
# Track : Fur Elise ★★★★★
# Album : Für Elise
# Artist: Beethoven
# Time  : 0:01/3:92
current_song(){
	osascript <<-PPLESCRIPT
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
	PPLESCRIPT
}


state(){
	state=`osascript -e 'tell application "iTunes" to player state as string'`;
	echo "iTunes is currently $state.";
	if [ $state = "playing" ]; then
		current_song
	fi
}


list_current_playlist(){
	osascript <<-PPLESCRIPT
	tell application "iTunes"
		set names to the name of every track of current playlist
		set AppleScript's text item delimiters to "\n"
		if (count of names) > 10 then
			set lst to items 1 thru 10 of names as text
		else
			set lst to names as text
		end if
	end tell
	PPLESCRIPT
	
}

list_current_playlist_all(){
	osascript <<-APPLESCRIPT
	tell application "iTunes"
		set names to the name of every track of current playlist
		set AppleScript's text item delimiters to "\n"
		set lst to name of current playlist & "\n\n" & names as text
	end tell
	APPLESCRIPT
}

list_comands(){
	echo "status"
	echo "play"
	echo "pause"
	echo "playpause"
	echo "next"
	echo "prev"
	echo "rewind"
	echo "mute"
	echo "unmute"
	echo "vol"
	echo "search"
	echo "playlist"
	echo "current"
	echo "random"
	echo "shuffle"
	echo "repeat"
	echo "4.5"
	echo "1"
	echo "2"
	echo "3"
	echo "4"
	echo "5"
	echo "4.5"
	echo "stop"
	echo "quit"
}

if [ $# = 0 ]; then
	usage;
fi

while [ $# -gt 0 ]; do
	arg=$1;
	case $arg in
		"commands" )
			list_comands
			exit 0;
			break;;
		
		"status" | "s" ) state;
			break ;;
		
		"playpause" | "p" ) echo -n "Changing PlayState to ";
			state=`osascript -e 'tell application "iTunes"' -e 'playpause'  -e 'set state to player state as string' -e 'end tell'`; 
			echo $state
			[ "${state}x" == "playingx" ] && current_song
			break ;;
			
		"play" | "y"  ) echo "Playing iTunes.";
			osascript -e 'tell application "iTunes" to play';
			break ;;

		"pause" | "a" ) echo "Pausing iTunes.";
			osascript -e 'tell application "iTunes" to pause';
			break ;;
		
		"stop" | "t" ) echo "Stopping iTunes.";
			osascript -e 'tell application "iTunes" to stop';
			break ;;
		
		"next" | "n"  ) echo "Going to next track." ;
			osascript -e 'tell application "iTunes" to next track';
			current_song
			break ;;

		"prev" | "b" | "back" ) echo "Going to previous track.";
			osascript -e 'tell application "iTunes" to previous track';
			current_song
			break ;;
		"rewind" | "r" ) echo "Rewinding track.";
			osascript -e 'tell application "iTunes" to back track';
			break ;;

		"mute"         ) echo "Muting iTunes' volume level.";
		osascript -e 'tell application "iTunes" to set mute to true';
		break ;;

		"unmute"         ) echo "Unmuting iTunes' volume level.";
		osascript -e 'tell application "iTunes" to set mute to false';
		break ;;

		"m"           ) echo "(un)Muting iTunes volume level.";
		osascript -e 'tell application "iTunes" to set mute to not mute';
		break ;;

		"vol" | "v"    ) echo "Changing iTunes volume level.";
			if [ $# -gt 1 ]; then
				vol=`osascript -e 'tell application "iTunes"  to sound volume as integer'`;
				if [ $2 = "up" ]; then
					newvol=$(( vol+10 ));

				elif [ $2 = "down" ]; then
					newvol=$(( vol-10 ));

				elif [ $2 -gt 0 ]; then
					newvol=$2;
				fi
				osascript -e "tell application \"iTunes\" to set sound volume to $newvol";
			fi
			
			break ;;
		
		"playlist" | l ) 
			if [ $# -gt 1 ]; then
				echo "Playing $2";
				osascript -e "tell application \"iTunes\" to play playlist \"$2\""
			else 
				osascript <<-APPLESCRIPT
				tell application "iTunes"
					set allPlaylists to (get name of every playlist ¬
						where special kind = none ¬
						and name does not contain "pc"¬ 
						and name does not contain "kbs" ¬
						and name does not contain "Alfred.app Playlist" ¬
						and name does not contain "Some Random Album" ¬
						and name does not contain "select" ¬
						)
				end tell
				APPLESCRIPT
			fi
			break ;;
		"shuffle" | "f" )
			if [ $# -gt 1 ]; then
				if [[ "$2" == "on" || "$2" == "true" ]]; then
					echo "Turning shuffle on";
					osascript -e 'tell application "iTunes" to set shuffle of current playlist to 1';
				elif [[ "$2" == "off" || "$2" == "false" ]]; then
					echo "Turning shuffle off";
					osascript -e 'tell application "iTunes" to set shuffle of current playlist to 0';
				fi
			else
				echo "Toggling shuffle ";
				osascript -e 'tell application "iTunes" to set shuffle of current playlist to not shuffle of current playlist';
			fi
		break;;
		
		"repeat" | "e" )
			if [ $# -gt 1 ]; then
				if [ "$2" == "all" ]; then
					echo "Setting repeat to all";
					osascript -e 'tell application "iTunes" to set song repeat of current playlist to all';
				elif [ "$2" == "one" ]; then                                   
					echo "Setting repeat to one";                              
					osascript -e 'tell application "iTunes" to set song repeat of current playlist to one';
				elif [ "$2" == "off" ]; then                                   
					echo "Setting repeat to off";                              
					osascript -e 'tell application "iTunes" to set song repeat of current playlist to off';
				fi
			else
				echo "Needs all|one|off as a argument";
			fi
		break;;
		
		"current" | "c") 
			list_current_playlist_all | less
		break;;
	
		"$"            ) echo "Serching Library using name, album and comment as fields"; 
			shift; # get rids of $
			osascript <<-APPLESCRIPT
			tell application "iTunes"
				delete tracks of playlist "results"
				set searchResults to file tracks whose name contains "${*}" or album contain "${*}" or comment contains "${*}" 
				repeat with aTrack in searchResults
					copy aTrack to playlist "results"
				end repeat
				play playlist "results"
			end tell
			APPLESCRIPT

			list_current_playlist
		break;;		

		"search" | "@" ) echo "Searching Library.";
			if [ $# -gt 1 ]; then
				
				if  [[ $# -gt 2 && ( "$2" == "name" || "$2" == "album" || "$2" == "artist" \
							|| "$2" == "grouping" || "$2" == "composer" || "$2" == "year" \
							|| "$2" == "comment"  || "$2" == "genre"  \
					)]]; then
					
					type="$2";
					shift; # get rids of search/@
					shift; # get rid of type
										
					osascript <<-APPLESCRIPT
					tell application "iTunes"
						delete tracks of playlist "results"
						set searchResults to file tracks whose ${type} contains "${*}"
						repeat with aTrack in searchResults
							copy aTrack to playlist "results"
						end repeat
						play playlist "results"
					end tell
					APPLESCRIPT
					
				else 
					
					shift;  # get rids of search/@
					
					osascript <<-APPLESCRIPT
					tell application "iTunes"
						delete tracks of playlist "results"
						set searchResults to search playlist "Music" for "${*}"
						repeat with aTrack in searchResults
							copy aTrack to playlist "results"
						end repeat
						play playlist "results"
					end tell
					APPLESCRIPT
					
				fi
				
				list_current_playlist
			fi 
 		break ;;
		
		[0-5] ) echo "Set rating to $arg stars?"
			current_song
			RATE=0
			
			if [ $# -gt 1 ]; then
				RATE=1
			else
				select ANS in "Yes" "No"; do
					if [ "${ANS}" == "Yes" ]; then
						RATE=1
					fi;
					break;
				done;
			fi
			
			if [ ${RATE} -eq 1 ]; then
				osascript -e 'tell application "iTunes"' -e \
					"set the rating of the current track to $((${arg}*20)) as integer"\
				-e 'end tell';
			fi
			break ;;
		
		# bash does not do floating points calc
		"4.5" | 6) echo "Set rating to 4½ stars?"
		current_song
		RATE=0
		
		if [ $# -gt 1 ]; then
			RATE=1
		else
			select ANS in "Yes" "No"; do
				if [ "${ANS}" == "Yes" ]; then
					RATE=1
				fi;
				break;
			done;
		fi
		
		if [ ${RATE} -eq 1 ]; then
			osascript -e 'tell application "iTunes"' -e \
				"set the rating of the current track to 90 as integer"\
			-e 'end tell';
		fi
		break ;;
	
		"quit" | "q" ) echo "Quitting iTunes.";
			osascript -e 'tell application "iTunes" to quit';
			exit 1 ;;

		"u"          ) 
			if [ $# -gt 1 ]; then
				echo "Playing µ$2";
				osascript -e "tell application \"iTunes\" to play playlist \"µ$2\""
			fi
			break ;;
		"o"          ) 
			if [ $# -gt 1 ]; then
				echo "Playing Ω$2";
				osascript -e "tell application \"iTunes\" to play playlist \"Ω$2\""
			fi
			break ;;
			
		"random" | "rnd" | "d" ) echo "Playing a random album";
		osascript &> /dev/null <<-PPLESCRIPT
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
		PPLESCRIPT
		current_song
		break;;
		
		h* | -h | --help ) echo "help:";
			usage;
		break ;;
		
		*      ) echo "Invaild";
		break;;
	esac
done                                                      

## idea - ascii art of cover art?
##  jp2a /Users/bilalh/Desktop/Untitled.jpg -i --height=10