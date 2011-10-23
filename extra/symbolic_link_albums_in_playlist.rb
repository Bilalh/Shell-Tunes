#!/usr/bin/env ruby19 -wKU
# Bilal Hussain 
# Symbolic links the  albums in the specifed playlist in itunes to the specifed folder

require 'escape'

(puts "#{File.basename $0} <playlist> <dir>"; exit) unless ARGV.length == 2

playlist = ARGV[0]
dir      = ARGV[1]

albums   = `albums.applescript #{Escape.shell_command [playlist] }`.split(',')
exit if albums == ""

albums.each do |album|
	album.strip!
	puts "Symbolic linking #{album} to #{dir}/#{album}"
	tracks = `get_album_filepaths.applescript #{Escape.shell_command [album] }`.split("\n")
	album.gsub!(/^\./, "dot ")
	album.gsub!(/\//, "_")
	next if tracks == "" 
	`mkdir -p #{Escape.shell_command ["#{dir}/#{album}"] }`
	tracks.each do |track|
		`ln -s #{track} #{Escape.shell_command ["#{dir}/#{album}"] }`
	end
end