tell application "iTunes" to set current to the rating of current track as string
set stars to current / 20 as integer
set half to current mod 20 = 10
if half then set stars to stars & "½"
stars as string