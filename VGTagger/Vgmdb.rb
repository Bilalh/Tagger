#!/usr/bin/env ruby19 -KU
# encoding: UTF-8
require 'rubygems'
require 'htmlentities'
require 'nokogiri'

require 'open-uri'
require 'fileutils'
require 'cgi'


# gets data from vgmdb 
class Vgmdb
	
	def initialize()
		@names = {
			'en'       => :@english,
			'ja'       => :@japanese,
			'ja-Latn'  => :@romaji,
			'English'  => :@english,
			'Japanese' => :@japanese,
			'Romaji'   => :@romaji,
		}
	end
	
	def search(string)
		
		#url = "http://vgmdb.net/search?q=#{CGI.escape string}"
		url = File.expand_path("~/Desktop/test3.html")
		
		doc = Nokogiri::HTML(open(url).read)
		album_results = doc.css 'div#albumresults tr'
		rows_tr = album_results[1..-1]
		
		rows =[]
		
		rows_tr.each do |tr|
			row = {}
			row[:catalog]  = tr.children[0].text
			row[:released] = tr.children[3].text
			row[:album]    = spilt_lang tr.children[2].children[0].children
			row[:url]      = tr.children[2].children[0]['href']
			rows<<row
		end
		
		return rows
	end
	
	
	# Returns the data at the vgmdb url as a hash
	def get_data(url)
		doc = Nokogiri::HTML(open(url).read)
		
		hash = {}
		get_titles(doc,hash)
		get_meta(doc,hash)
		get_tracks(doc,hash)
		get_notes(doc,hash)
		return hash
	end
	
	def get_meta(doc,hash)
		puts "Getting metadata"
		
		meta = doc.css('table#album_infobit_large')
		
		# get the data from the specific row
		get_data       = ->(id){  return meta.children[id].children[2].text.strip  }
		# get the data from the specific row spilt into lang
		get_spilt_data = ->(id){  
			arr = [] 
			meta.children[id].children[2].children.each do |e|
				if e.children.length > 0 then
					arr << spilt_lang(e.children)
				end
			end
			return arr
		}
		
		hash[:catalog]   = get_data[0]
		hash[:date]      = get_data[1]
		hash[:year]      = hash[:date][/\d{4}$/]
		hash[:publisher] = get_spilt_data[6]
		hash[:composer]  = get_spilt_data[8]
		hash[:arranger]  = get_spilt_data[8]
		hash[:performer] = get_spilt_data[9]
				
				
		stats     = doc.css('tr> td#rightcolumn > div > div.smallfont > div > b')
		get_stats = ->(id){  return stats[id].next.next.text.strip  }
		
		hash[:category] = get_stats[2]
		
		ps = ->(id){ 
			if stats[id].next.next.children.length > 0 then
				 spilt_lang(stats[id].next.next.children)
			else 
				stats[id].next.next.text.split(', ').map { |e| {:@english => e.strip} }
			end
		}
		
		hash[:products] =  ps[3]
		hash[:platforms] = ps[4]
		puts
	end
	
	def get_titles(doc, hash)
		puts "Getting Titles"
		titles ={}
		titles = spilt_lang(doc.css('h1 > span.albumtitle'))
		hash[:title] = titles
		
		puts
	end

	def get_notes(doc,hash)
		puts "Getting notes"
		notes = ""
		doc.css('div.page table tr td div div.smallfont')[-1].children.each do |e|
		notes <<  e.text  << "\n" if e.text != ""
		end
		hash[:notes] = HTMLEntities.new.decode notes
	end
	
	def get_tracks(doc, hash)
		coder = HTMLEntities.new
		
		puts "Getting Tracks"
		# Gets the id of each language
		
		refs = []
		doc.css('ul#tlnav>li>a').each do |ele|
			refs << {lang: @names[ele.text], ref:ele['rel'] }
		end
		puts "refs:"
		puts refs
		
		tracks = {}
				
		refs.each do |ref|
			disc_tables = doc.css("span##{ref[:ref]}>table")
			num_discs = disc_tables.length
			hash[:total_discs] = num_discs
			puts "Getting #{ref[:lang]} tracks, #{num_discs} Discs"
			
			disc_tables.each_with_index do |disc,disc_index|
				disc_num = disc_index + 1;
				puts "disc #{disc_num}"
				disc.css('tr').each do |track_tr|
					num = track_tr.children[0].text.to_i(10)
					
					# gets the track
					track = 
					if tracks.include? "#{disc_num}-#{num}" then
						tracks["#{disc_num}-#{num}"]
					else 
						track                        = Track.new
						track.track_num              = num
						track.disc_num               = num_discs
						track.time                   = track_tr.children[4].text
						tracks["#{disc_num}-#{num}"] = track
					end
					
					track.instance_variable_set(ref[:lang], coder.decode(track_tr.children[2].text))
					p track
				end
				
				puts
			end
			
		end
		
		hash[:tracks]= tracks;
		puts
	end #get_tracks
	
	private 
	# splits the different langs into a hash
	def spilt_lang(elems)
		h = {}
		elems.each do |ele|
			#TODO check for nothing
			lang = (ele.has_attribute? 'lang') ? @names[ele['lang']] : :@english
			h[lang] = ele.text.strip.sub /^\/ /, "" # !> ambiguous first argument; put parentheses or even spaces
		end
		return h
	end
	
end

class Track
	attr_accessor :engish, :japanese, :romaji, :track_num, :disc_num, :time
end

if $0 == __FILE__
	vg = Vgmdb.new()
	puts vg.search("Atelier Meruru"); exit

	#url = "http://vgmdb.net/album/13192"
	# url = 'http://vgmdb.net/album/3885'
	# url = File.expand_path("~/Desktop/test.html")
	url = File.expand_path("~/Desktop/test2.html")
	hash = vg.get_data(url)
	puts "Data"
	hash.each_pair do |name, val|
		puts "#{name} => #{val}"
	end

end


