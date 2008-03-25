#!/usr/bin/env ruby
require 'drb'

class Array
	def randomize
		arr = self.dup
		self.collect { arr.slice!(rand(arr.length)) }
	end

	def randomize!
		arr = self.dup
		result = self.collect { arr.slice!(rand(arr.length)) }
		self.replace result
	end
end

class Wallpaper

	def initialize
		@index = 0
		@wallpaper_dir = '/home/wfisher/wallpapers'
		reload
	end
	
	def reload
		@index = 0
		@wp = Dir.glob(@wallpaper_dir + '/*')
		@wp.randomize!
	end
	
	def set_bg(wp, index)
		puts "Setting wallpaper to #{wp[index]}"
		return if wp[index].nil?
		`fbsetbg -f #{wp[index]}`
	end
	
	def go
		@index += 1
		@index = 0 if @index > @wp.length
	
		set_bg(@wp, @index)
	end
	
	def back
		@index -= 1
		@index = @wp.length if @index < 0
	
		set_bg(@wp, @index)
	end

	def count
		@wp.length
	end
end

server = Wallpaper.new
DRb.start_service('druby://localhost:9000', server)
while(1)
	server.go
	DRb.thread.join(300)
end
