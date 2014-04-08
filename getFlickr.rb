#!/usr/bin/ruby
require 'flickraw'
require 'pit'

ENV['EDITOR'] ||= 'vim'
config = Pit.get('FlickApp', :require => { 'api_key' => 'Flickr API Key', 'shared_secret'  => 'Flickr Shared Secret', 'access_token' => 'Flickr Access Token', 'access_secret' => 'Flickr Access Secret', 'user_id' => 'Flickr User ID'})

FlickRaw.api_key = config['api_key']
FlickRaw.shared_secret = config['shared_secret']
flickr.access_token = config['access_token']
flickr.access_secret = config['access_secret']
userid = config['user_id']

photoid = ARGV[0]

info = flickr.photos.getInfo(:photo_id => photoid)

username = info.owner.username
profile_url = FlickRaw.url_profile(info)

title = info.title
date = info.dates.taken
src_url = FlickRaw.url(info)
url = FlickRaw.url_photopage(info)

license = ""
license_code = info.license
license_list = flickr.photos.licenses.getInfo

license_list['license'].each do | each_license |
	license = each_license['name'] if each_license['id'] == license_code
end

exif = flickr.photos.getExif(:photo_id => photoid)

camera = exif['camera']

exposure, exposureR, f_number, iso, focal, lensModel, lensType, lens = ""

exif['exif'].each do | each_exif |
	exposure  = each_exif['clean'] if each_exif['tag'] == 'ExposureTime'
	exposureR = each_exif['raw']   if each_exif['tag'] == 'ExposureTime'
	f_number  = each_exif['clean'] if each_exif['tag'] == 'FNumber'
	iso       = each_exif['raw']   if each_exif['tag'] == 'ISO'
	focal     = each_exif['clean'] if each_exif['tag'] == 'FocalLength'
	lensModel = each_exif['raw']   if each_exif['tag'] == 'LensModel'
	lensType  = each_exif['raw']   if each_exif['tag'] == 'LensType'
end

if (exposure == nil) then
	exposure = exposureR
	if (exposure != nil) then
		exposure = exposure + " sec"
	end
end

lens = (lensModel == nil ) ? lensType : lensModel

if (lens != nil && lens != "") then
#	lens = "(" + lens + ")"
end

	exif_content = "#{camera}#{lens}<br />#{focal}, #{f_number}, ISO#{iso}, #{exposure}"
	content = "<a href=\"#{url}\" title=\"#{title} by #{username}, on Flickr\" target=\"_blank\"><img src=\"#{src_url}\" width=\"500\" height=\"333\" alt=\"#{title}\"></a><br />#{title} by <a href=\"#{profile_url}\">#{username}</a>, on Flickr<br /><div class=\"flickr-exif\">#{exif_content}</div>(#{license})<br />\n\n"

puts content

