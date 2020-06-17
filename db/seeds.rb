# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'net/http'
require 'uri'
require 'json'

KEY_ID = '8c3588ed9e7efdb4b8aabb5d5768ee82'
AREA_CODE_S = 'AREAS2288'
HIT_PER_PAGE = '5'

url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&hit_per_page=#{HIT_PER_PAGE}"

uri = URI.parse(url)
json = Net::HTTP.get(uri)
result = JSON.parse(json)



puts result["rest"][0]["id"]
puts result["rest"][0]["name"]
puts result["rest"][0]["category"]
puts result["rest"][0]["image_url"]["shop_image1"]