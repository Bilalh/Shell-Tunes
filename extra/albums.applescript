#!/usr/bin/env osascript
# Bilal Hussain

# Returns a sorted list of every album (without dups) in a the specifed playlist.

on run argv
	tell application "iTunes"
		
		set pName to item 1 of argv as string
		with timeout of 300 seconds
			
			#activate
			
			# the list we'll populate
			set listOfAlbumNames to {}
			set itunesLibrary to a reference to (get playlist pName)
			set totalNumberOfTracks to (count of every track in itunesLibrary)
			
			# loop through each track, adding unique album names to the list    
			repeat with i from 1 to totalNumberOfTracks
				try
					set currentTrack to (a reference to track i of itunesLibrary)
					set currentAlbumName to (currentTrack's album as string)
					if currentAlbumName is not "" then
						if listOfAlbumNames does not contain currentAlbumName then
							copy currentAlbumName to end of listOfAlbumNames
						end if
					end if
				end try
			end repeat
			
		end timeout
		
	end tell
	
	# sort the album list
	set sortedAlbums to mergeSort(listOfAlbumNames)
end run

# Sorts the list
on mergeSort(theList)

	script bs
		property alist : theList
		
		on merge(leftSide, rightSide)
			set newList to {}
			set theLeft to leftSide
			set theRight to rightSide
			set leftLength to length of theLeft
			set rightLength to length of theRight
			repeat while leftLength > 0 and rightLength > 0
				if first item of theLeft ² first item of theRight then
					set newList to newList & first item of theLeft
					set theLeft to (rest of theLeft)
				else
					set newList to newList & first item of theRight
					set theRight to rest of theRight
				end if
				set leftLength to length of theLeft
				set rightLength to length of theRight
			end repeat
			if leftLength > 0 then set newList to newList & theLeft
			if rightLength > 0 then set newList to newList & theRight
			return newList
		end merge
	end script
	
	set midList to 0
	set leftList to {}
	set rightList to {}
	set listLength to length of bs's alist
	if listLength ² 1 then
		return bs's alist
	else
		set midList to listLength div 2
		repeat with pointer from 1 to midList
			set leftList to leftList & item pointer of bs's alist
		end repeat
		repeat with pointer from (midList + 1) to listLength
			set rightList to rightList & item pointer of bs's alist
		end repeat
		set leftList to mergeSort(leftList)
		set rightList to mergeSort(rightList)
	end if
	return bs's merge(leftList, rightList)
end mergeSort

