#!/usr/bin/env ruby19 -KU
# makes all the field declarations and definitions

require "pp"

#  Fields which are not strings
NotStringFields = %w{
	TRACK YEAR GENRE 	TOTAL_TRACKS TOTALS_DISCS
	DISC_NO COVER_ART BPM MUSICBRAINZ_ARTISTID
	MUSICBRAINZ_RELEASEID MUSICBRAINZ_RELEASEARTISTID MUSICBRAINZ_TRACK_ID MUSICBRAINZ_DISC_ID MUSICIP_ID AMAZON_ID
}

Basic = %w{
	ARTIST
	ALBUM
	TITLE
	YEAR
	GENRE
}

lines = IO.read("fields.txt").split "\n"

# Gets the fields names in CamaelCase
fields = lines[0].split("\t").map { |e| e.strip.gsub(/ (.)/,'\1'.upcase).to_sym }
print "// "
 p  fields +[:Name,:ObjcName,:Setter ] 

setter_length = 0

arr = lines[1..-1].map do |line|
	values = {}
	line.split("\t").each_with_index do |value, i|
		values[fields[i]] = value.strip
	end
	values[:Name]     = values[:Attribute].gsub( / /, '_').upcase
	values[:ObjcName] = values[:Name].downcase.gsub /_(.)/ do |e|  e[1].upcase end
	values[:Setter]   = "set" + values[:ObjcName].gsub(/^(.)/) do |e|  e[0].upcase end
	# puts "#{values[:Attribute]}, #{values[:Name]}, #{values[:ObjcName]}, #{values[:Setter]}"
	
	setter_length = values[:Setter].length if values[:Setter].length > setter_length
	values
end
names_length = setter_length - 3;

puts "// MP4 Fields"
arr.each do |values|
	puts %{String const #{"%-#{setter_length}s" % values[:Name]} = "#{values[:Mp4]}";}
end
puts


puts "// MP3 (:ID3v24) Fields declarations"
arr.each do |values|
	puts %{extern const char* #{values[:Name]};}
end
puts


puts "// MP3 (:ID3v24) Fields definitions"
arr.each do |values|
	puts %{const char* #{"%-#{setter_length}s" % values[:Name]} = "#{values[:ID3v24]}";}
end
puts



puts "// @property"
arr.each do |values|
	next if NotStringFields.include? values[:Name]
	puts <<-OBJC
/// The #{values[:Attribute]} of the file
@property (assign) NSString *#{values[:ObjcName]}
OBJC
end
puts

puts "// @synthesize"
i =0;
arr.each_with_index { |e, i|  }
arr.each_with_index do |values,j|
	next if NotStringFields.include? values[:Name]
	print "\n@synthesize " if i % 5 == 0
	print values[:ObjcName] 
	i+=1;
	print ', ' if  j != arr.length-1 && i % 5 != 0
end
puts

puts "\n// Tags functions"
arr.each do |values|
	next if NotStringFields.include? values[:Name] or Basic.include? values[:Name]
	puts <<-OBJC
- (void) #{"%-#{setter_length}s" % values[:Setter]}:(NSString*)newValue {}
OBJC
end
puts

puts "// MP3/Mp4 functions"
arr.each do |values|
	next if NotStringFields.include? values[:Name] or Basic.include? values[:Name]
	puts <<-OBJC
- (void) #{values[:Setter]}:(NSString*)newValue
{
	TAG_SETTER_START(#{values[:ObjcName]});
	[self setFieldWithString:#{values[:Name]} value:newValue];
}

	OBJC
end
puts

puts "//tagFieldNames\n [[NSArray alloc] initWithObjects:"
i =0;
arr.each_with_index { |e, i|  }
arr.each_with_index do |values,j|
	next if NotStringFields.include? values[:Name]
	print "\n " if i % 5 == 0
	print %{@"#{values[:ObjcName]}"} 
	i+=1;
	print ', ' if  j != arr.length-1 && i % 5 != 0
end
puts ", nil];"
puts
