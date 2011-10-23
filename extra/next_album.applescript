#!/usr/bin/env osascript
-- Bilal Hussain 
tell application "iTunes"
    pause
    set |current album| to the album of the current track
    repeat while the album of the current track is equal to |current album|
        next track
    end repeat
    play
end tell