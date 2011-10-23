#!/usr/bin/env ruby19 -wKU
# Bilal Hussain 
# Symbolic links the selected tracks in itunes to the specifed folder

require 'escape'

(puts "#{File.basename $0} <dir>"; exit) if ARGV.length ==0

dir = ARGV[0]
paths = `get_selected_tracks_filepaths.applescript`.split(/\n/)
exit if paths == ""

system "mkdir", "-p", dir
paths.each do |path|
	`ln -s #{path} #{Escape.shell_command [dir] }`
end