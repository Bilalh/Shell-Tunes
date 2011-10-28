#!/usr/bin/env ruby19 -wKU
# Bilal Hussain 
# Symbolic links the  albums in the specifed playlist in itunes to the specifed folder

require 'escape'

(puts "#{File.basename $0} <playlist> <dir>"; exit) unless ARGV.length == 2

playlist = ARGV[0]
dir      = ARGV[1]

tracks   = `get_filepath_of_every_track_in_playlist.applescript #{Escape.shell_command [playlist] }`.split("\n")
exit if tracks == ""

playlist = playlist.gsub(/^\./, "dot ")
playlist = playlist.gsub(/\//, "_")
puts "Symbolic linking #{playlist} to #{dir}/#{playlist}"
`mkdir -p #{Escape.shell_command ["#{dir}/#{playlist}"] }`
tracks.each_with_index do |track, i|
	# puts %{ln -s #{track} #{Escape.shell_command ["#{dir}/#{playlist}"] }}
	`ln -s #{track} #{Escape.shell_command ["#{dir}/#{playlist}/#{"%04d" % i} #{File.basename(track).gsub(/(\.\w+)'$/, '\1') }"] }`
end