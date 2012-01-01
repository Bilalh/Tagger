#!/usr/bin/env ruby19 -KU
# makes all the field declarations and definitions

require "pp"

#  Fields which are not strings
NumberFields = %w{
	TRACK_NUMBER TOTAL_TRACKS TOTAL_DISCS
	DISC_NUMBER  BPM YEAR COMPILATION
}

NotStringFields = NumberFields + ["COVER"]

Basic = %w{
	ARTIST
	ALBUM
	TITLE
	YEAR
	GENRE
	COMMENT
}

def get_type(val)
	type = case 
		when (NumberFields.include? val); "NSNumber"
		when val =="COVER"; "NSImage"
		else "NSString"
	end
end

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
	values[:Name] = values[:Attribute].gsub( / /, '_').upcase
	values[:ObjcName]  = values[:Name].downcase.gsub(/_number/,'').gsub /_(.)/ do |e|  e[1].upcase end
	values[:Setter]    = "set" + values[:ObjcName].gsub(/^(.)/) do |e|  e[0].upcase end
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

puts "// vars"
arr.each do |values|	
	puts %{ #{get_type values[:Name]} *#{values[:ObjcName]};}
end
puts

puts "// @property"
arr.each do |values|
	puts <<-OBJC
/// The #{values[:Attribute]} of the file
@property (assign) #{get_type values[:Name]} *#{values[:ObjcName]};
OBJC
end
puts

puts "// @synthesize"
i =0;
arr.each_with_index { |e, i|  }
arr.each_with_index do |values,j|
	print "\n@synthesize " if i % 5 == 0
	print values[:ObjcName] 
	i+=1;
	print (j != arr.length-1 && i % 5 != 0) ? ', ' : ";"
end
puts

puts "\n// Tags methods"
arr.each do |values|
	next if  Basic.include? values[:Name]
	puts <<-OBJC
- (void) #{"%-#{setter_length}s" % values[:Setter]}:(#{get_type values[:Name]}*)newValue {}
OBJC
end
puts

puts "// MP3/Mp4 methods"
arr.each do |values|
	next if NotStringFields.include? values[:Name] or Basic.include? values[:Name]
	puts <<-OBJC
- (void) #{values[:Setter]}:(#{get_type values[:Name]}*)newValue
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
	print "\n " if i % 5 == 0
	print %{@"#{values[:ObjcName]}"} 
	i+=1;
	print ', ' if  j != arr.length-1
end
puts ", nil];"
puts


puts "\n// file sys node methods"
arr.each do |values|
	puts <<-OBJC
- (void) #{"%-#{setter_length}s" % values[:Setter]}:(#{get_type values[:Name]}*)newValue {SETTER_METHOD_FSN(newValue, #{values[:ObjcName]} )}
OBJC
end
puts

