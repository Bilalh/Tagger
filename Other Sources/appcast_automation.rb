#!/usr/bin/env ruby -w
#
# appcast_automation.rb 
# Bilal Syed Hussain
#
# based off https://github.com/CraigWilliams/appcastautomation/blob/SnowLeopard/appcast_automation.rb
# Licensed under GNU General Public License
class AppCast
	require 'rubygems'
	require 'yaml'
	require 'tmpdir'
	require 'fileutils'
	require 'openssl'
	require 'nokogiri'
	require 'base64'
	require "maruku"
	
	MESSAGE_HEADER          = 'RUN SCRIPT DURING BUILD MESSAGE'
	YAML_FOLDER_PATH        = "#{ENV['PROJECT_DIR']}/Resources"
	def initialize
		@signature = ''
		require_release_build
		instantiate_project_variables
		load_config_file

		# the build_now setting in the config.yaml file
		# set to 'NO' until you are ready to publish
		exit_if_build_not_set_to_yes
		instantiate_appcast_variables
	end

	def main_worker_bee
		create_appcast_folder_and_files
		remove_old_zip_create_new_zip
		file_stats
		create_key
		create_appcast_xml
		copy_archive_to_appcast_path
	end

	# Only works for Release builds Exits upon failure
	def require_release_build
		if ENV["BUILD_STYLE"] == 'Debug'
			log_message("Distribution target requires 'Release' build style")
			exit
		end
	end

	# Exits if no config.yaml file found.
	def load_config_file
		config_file_path = "#{YAML_FOLDER_PATH}/config.yaml"
		if !File.exists?(config_file_path)
			log_message("No 'config.yaml' file found in project directory.")
			exit
		end
		@config = YAML.load_file(config_file_path)
	end

	def exit_if_build_not_set_to_yes
		if @config['build_now'] != 'YES'
			log_message("The 'build_now' setting in 'config.yaml' set to 'NO'\nIf you are wanting to include this script in\nthe build process change this setting to 'YES'")
			exit
		end
	end

	def instantiate_project_variables
		@proj_dir         = ENV['BUILT_PRODUCTS_DIR']
		@proj_name        = ENV['PROJECT_NAME']
		@version          = `defaults read "#{@proj_dir}/#{@proj_name}.app/Contents/Info" CFBundleShortVersionString`
		@build_number     = `defaults read "#{@proj_dir}/#{@proj_name}.app/Contents/Info" CFBundleVersion`
		@archive_filename = "#{@proj_name}_#{@version.chomp}.zip" # underline character added
		@archive_path     = "#{@proj_dir}/#{@archive_filename}"
	end

	def instantiate_appcast_variables
		@appcast_xml_name      = @config['appcast_xml_name'].chomp
		@appcast_basefolder    = @config['appcast_basefolder'].chomp
		@appcast_proj_folder   = "#{@config['appcast_basefolder']}/#{@proj_name}_#{@version}".chomp
		@appcast_xml_path      = "#{@appcast_proj_folder}/#{@appcast_xml_name}"
		@download_base_url     = @config['download_base_url']
		@keychain_privkey_name = @config['keychain_privkey_name']
		@css_file_name         = @config['css_file_name']
		@releasenotes_url      = "#{@download_base_url}#{@version.chomp}.html"
		@appcast_download_url  = "#{@download_base_url}#{@appcast_xml_name}"
		@download_url          = 
			if @config['github_hosted_downloads'] &&  @config['github_username']  then
                current_tag=@version.chomp.split(".")[0,3]
                current_tag=current_tag.join(".")
                
				"https://github.com/#{@config['github_username']}/#{@proj_name}/releases/download/#{current_tag}/#{@archive_filename}"
                # example
                # https://github.com/Bilalh/Tagger/releases/download/1.8.0/Tagger_1.8.0.6.zip
			else
				"#{@download_base_url}#{@archive_filename}"
			end
		@markdown_readme       = 
			if @config['markdown_changelog'] then
				"#{ENV['PROJECT_DIR']}/#{@config['markdown_changelog']}"
			else
				nil
			end
	end

	def remove_old_zip_create_new_zip
		Dir.chdir(@proj_dir)
		`rm -f #{@proj_name}*.zip`
		`ditto -c -k --keepParent -rsrc "#{@proj_name}.app" "#{@archive_filename}"`
	end

	def copy_archive_to_appcast_path
		begin
			FileUtils.mv(@archive_path, @appcast_proj_folder)
		rescue
			log_message("There was an error copying the zip file to appcast folder\nError: #{$!}")
		end
	end

	def file_stats
		@size			= File.size(@archive_filename)
		@pubdate	= `date +"%a, %d %b %G %T %z"`
	end
	
	def get_key
		key_xml = `security find-generic-password -g -s "#{@keychain_privkey_name}" 2>&1 1>/dev/null`
		xml = key_xml.gsub(/\\012/, "\n")
		xml = "<?xml version=".concat(xml.split("<?xml version=")[1])
		doc = Nokogiri::XML(xml)
		doc.xpath("//key").xpath("//string").text
	end

	def create_key
		key = get_key

		if key.empty?
			log_message("Unable to load signing private key with name '#{@keychain_privkey_name}' from keychain\nFor file #{@archive_filename}")
			exit
		end

		hashed = OpenSSL::Digest::SHA1.digest(File.read("#{@archive_path}"))
		dsa = OpenSSL::PKey::DSA.new(key)
		dss1 = OpenSSL::Digest::DSS1.new
		sign = dsa.sign(dss1, hashed)
		@signature = Base64.encode64(sign)
		@signature = @signature.gsub("\n", '')

		if @signature.empty?
			log_message("Unable to sign file #{@archive_filename}")
			exit
		else
			log_message("New signature is \n#{@signature}")
		end
	end

	def create_appcast_xml
		appcast_xml = <<-HTML 
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle"  xmlns:dc="http://purl.org/dc/elements/1.1/">
	<channel>
		<title>#{@proj_name}</title>
		<link>#{@appcast_download_url}</link>
		<description>Most recent changes with links to updates.</description>
		<language>en</language>
		<item>
			<title>Version #{@version.chomp}</title>
			<sparkle:releaseNotesLink>
				#{@releasenotes_url}
			</sparkle:releaseNotesLink>
			<pubDate>#{@pubdate.chomp}</pubDate>
			<enclosure url="#{@download_url.chomp}"
			length="#{@size}"
			type="application/octet-stream"
			sparkle:version="#{@build_number.chomp}"
			sparkle:shortVersionString="#{@version.chomp}"
			sparkle:dsaSignature="#{@signature.chomp}"/>
		</item>
	</channel>
</rss>
		HTML

		File.open(@appcast_xml_path, 'w') { |f| f.puts appcast_xml }
	end

	# Creates the appcast folder if it does not exist or is accidently moved or deleted
	# Creates an html file with generic note template if it does not exist
	# This way the notes file is named correctly as well
	# Creates a css file named from yaml file with default css
	def create_appcast_folder_and_files
		base_folder = @appcast_basefolder
		project_folder = @appcast_proj_folder

		notes_file = "#{project_folder}/#{File.basename(@releasenotes_url.chomp)}"
		css_file_path = "#{project_folder}/#{@css_file_name}"

		Dir.mkdir(base_folder)    if !File.exists?(base_folder)
		Dir.mkdir(project_folder) if !File.exists?(project_folder)

		File.open(notes_file, 'w')    { |f| f.puts release_notes_generic_text } unless File.exists?(notes_file)
		File.open(css_file_path, 'w') { |f| f.puts decompressed_css } unless File.exists?(css_file_path)
	end

	def log_message(msg)
		puts "\n\n----------------------------------------------"
		puts MESSAGE_HEADER
		puts msg
		puts "----------------------------------------------\n\n"
	end

	def decompressed_css
		return css_text.gsub(/\{\s+/, "{\n\t").gsub(/;/, ";\n\t").gsub(/^\s+\}/, "}").gsub(/^\s+/, "\t")
	end

	def release_notes_generic_text
		
		default = <<-HTML
		<p>
			<ul>
				<li>DESCRIPTION</li>
			</ul>
		</p>
		HTML
		
		return <<-HTML
		<html>
		<head>
			<meta http-equiv="content-type" content="text/html;charset=utf-8">
			<title>What's new in #{@proj_name}?</title>
			<meta name="robots" content="anchors">
			<link href="rnotes.css" type="text/css" rel="stylesheet" media="all">
		</head>

		<body>
			<br />
			<table class="dots" width="100%" border="0" cellspacing="0" cellpadding="0" summary="Release Notes table ">
				<tr>
					<td class="blue" colspan="2">
						<h1 id='title'>Release Notes</h1>
					</td>
				</tr>
				<tr>
					<td valign="top" id='content'>
					#{if @markdown_readme then convert_readme else default end}
					</td>
				</tr>
			</table>
			<br>
		</body>
		</html>
		HTML
	end
	
	def convert_readme
		Maruku.new(File.read @markdown_readme).to_html
	end

	def css_text
		return <<-CSS
		body {
			margin: 2px 12px 12px;
		}

		h1 {
			display: none;
			visibility: hidden;
			font-size: 12pt;
			margin-bottom: 0;
		}

		h1#title {
			display: block;
			visibility: visible;
		}

		h2 {
			background-color: #e6edff;
			font-size: 11pt;
			margin-top:30px;
		}

		td#content>h2:first-of-type {
			margin-top:10px;
		}

		h3 {
			font-size: 10pt;
			font-weight: bold;
			margin-bottom: -4px;
		}

		h1 h2 h3 p ol ul a a:hover {
			font-family: "Lucida Grande", Arial, sans-serif;
		}

		h3,h4,h5 {
			color: #335E8D;
			font-weight : normal;
			border-bottom : 1px dotted #ccc;
			margin-left : 3px;
			font-variant : small-caps;
			font-weight : normal;
			border-bottom : 1px dotted #ccc;
		}

		p {
			font-size: 9pt;
			line-height: 12pt;
			text-decoration: none;
		}
		ol {
			font-size: 9pt;
			line-height: 12pt;
			list-style-position: outside;
			margin-top: 12px;
			margin-bottom: 12px;
			margin-left: -18px;
			padding-left: 40px;
		}
		ol li {
			margin-top: 6px;
			margin-bottom: 6px;
		}
		ol p {
			margin-top: 6px;
			margin-bottom: 6px;
		}
		ul {
			font-size: 9pt;
			line-height: 12pt;
			list-style-type: square;
			list-style-position: outside;
			margin-top: 12px;
			margin-bottom: 12px;
			margin-left: -24px;
			padding-left: 40px;
		}
		ul li {
			margin-top: 6px;
			margin-bottom: 6px;
		}
		ul p {
			margin-top: 6px;
			margin-bottom: 6px;
		}
		a {
			color: #00f;
			font-size: 9pt;
			line-height: 12pt;
			text-decoration: none;
		}
		a:hover {
			color: #00f;
			text-decoration: underline;
		}
		hr {
			text-decoration: none;
			border: solid 1px #bfbfbf;
		}
		td {
			padding: 6px;
		}
		#banner {
			background-color: #f2f2f2;
			background-repeat: no-repeat;
			padding: -2px 6px 0;
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			height: 1.2em;
			float: left;
			border: solid 1px #bfbfbf;
		}
		#caticon {
			margin-top: 3px;
			margin-bottom: -3px;
			margin-right: 5px;
			float: left;
		}
		#pagetitle {
			margin-top: 12px;
			margin-bottom: 0px;
			margin-left: 40px;
			width: 88%;
			border: solid 1px #fff;
		}
		#mainbox {
			margin-top: 2349px;
			padding-right: 6px;
		}
		#taskbox {
			background-color: #e6edff;
			list-style-type: decimal;
			list-style-position: outside;
			margin: 12px 0;
			padding: 2px 12px;
			border: solid 1px #bfbfbf;
		}
		#taskbox h2 {
			margin-top: 8;
			margin-bottom: -4px;
		}
		#machelp {
			position: absolute;
			top: 2px;
			left: 10px ;
		}
		#index {
			background-color: #f2f2f2;
			padding-right: 25px;
			top: 2px;
			right: 12px;
			width: auto;
			float: right;
		}
		#next {
			position: absolute;
			top: 49px;
			left: 88%;
		}
		#asindent {
			margin-left: 22px;
			font-size: 9pt;
			font-family: Verdana, Courier, sans-serif;
		}
		.bread {
			color: #00f;
			font-size: 8pt;
			margin: -9px 0 -6px;
		}
		.leftborder {
			color: #00f;
			font-size: 8pt;
			margin: -9px 0 -6px;
			padding-top: 2px;
			padding-bottom: 3px;
			padding-left: 8px;
			border-left: 1px solid #bfbfbf;
		}
		.mult {
			margin-top: -8px;
		}
		.blue {
			background-color: #e6edff;
		}
		.rightfloater {
			float: right;
			margin-left: 15px;
		}
		.rules {
			border-bottom: 1px dotted #ccc;
		}
		.dots {
			border: dotted 1px #ccc;
		}
		.seealso {
			margin-top: 4px;
			margin-bottom: 4px;
		}
		code {
			color: black;
			font-size: 9pt;
			font-family: Verdana, Courier, sans-serif;
		}
		CSS
	end
end

if __FILE__ == $0
	newAppcast = AppCast.new
	newAppcast.main_worker_bee
	newAppcast.log_message("It appears all went well with the build script!")
end
