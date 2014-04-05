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

exif = flickr.photos.getExif(:photo_id => photoid)

camera = exif['camera']

exposure, f_number, iso, focal, lensModel, lensType = ""

exif['exif'].each do | each_exif |
	exposure  = each_exif['clean'] if each_exif['tag'] == 'ExposureTime'
	f_number  = each_exif['clean'] if each_exif['tag'] == 'FNumber'
	iso       = each_exif['raw']   if each_exif['tag'] == 'ISO'
	focal     = each_exif['clean'] if each_exif['tag'] == 'FocalLength'
	lensModel = each_exif['raw']   if each_exif['tag'] == 'LensModel'
	lensType  = each_exif['raw']   if each_exif['tag'] == 'LensType'
end

lens = lensType ? lensModel : lensType

exif_content = "#{camera} ( #{lens} )<br />#{focal}, #{f_number}, #{iso}, #{exposure}"

content = "<a href=\"#{url}\" title=\"#{title} by #{username}, on Flickr\" target=\"_blank\"><img src=\"#{src_url}\" width=\"500\" height=\"333\" alt=\"#{title}\"></a><br />#{title} by <a href=\"#{profile_url}\">#{username}</a>, on Flickr<br /><div class=\"flickr-exif\">#{exif_content}</div>"

puts content

