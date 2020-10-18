namespace :db do
    desc "ビールメニューのInsertを行う"
    task :drink_beer_insert => :environment do
        require 'csv'

        CSV.read('csv/beer_drinks1.csv', headers: false).each do |row|
            drink = Drink.new(
                name: row[0],
                drink_type: 1
            )
            drink.save
        end
    end

    desc "ドリンクタイプのInsertを行う"
    task :drink_type_insert => :environment do
        require 'csv'

        CSV.read('csv/drink_type1.csv', headers: false).each do |row|
            drink_type = DrinkType.new(
                drink_type: row[0],
            )
            drink_type.save
        end
    end

    desc "ビール対応表のInsertを行う"
    task :beer_correspondence_insert => :environment do
        require 'csv'

        CSV.read('csv/beer_correspondence1.csv', headers: false).each do |row|
            beer_correspondence = BeerCorrespondence.new(
                beer_name: row[0],
                drink_id: row[1]
            )
            beer_correspondence.save
        end
    end

    desc "APIら取得した店舗情報のInsertを行う"
    task :stores_insert => :environment do
        require 'net/http'
        require 'uri'
        require 'json'
        require "open-uri"
        require "nokogiri"

        # APIの Key, AREACODE(八王子), 取得件数
        KEY_ID       = '8c3588ed9e7efdb4b8aabb5d5768ee82'
        AREA_CODE_S  = 'AREAS2288'
        CATEGORY_L   = 'RSFST09000'
        HIT_PER_PAGE = 100
        offSet       = 1
        getData      = []

        #----------------- 検索でヒットする店舗数の取得 -----------------#
        countApiUrl = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&category_l=#{CATEGORY_L}&hit_per_page=#{HIT_PER_PAGE}"
        countUri      = URI.parse(countApiUrl)
        countJson     = Net::HTTP.get(countUri) #NET::HTTPを利用してAPIを叩く
        countResult   = JSON.parse(countJson) #返ってきたjsonデータをrubyの配列に変換
        total_hit_count =  countResult['total_hit_count']
        #----------------- ここまで -----------------#

        repetition = total_hit_count / 100 + 1 # for文で繰り返す回数を決める

        for num in 1..repetition do
            apiURL = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&category_l=#{CATEGORY_L}&offset=#{offSet}&hit_per_page=#{HIT_PER_PAGE}"

            uri             = URI.parse(apiURL)
            json            = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
            result          = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
            total_hit_count = result['total_hit_count'] # 検索でヒットした店舗数 Integer

            result['rest'].each do |rest|
                stores = Store.new(
                    store_id: rest['id'],
                    name: rest['name'],
                    name_kana: rest['name_kana'],
                    latitude: rest['latitude'],
                    longitude: rest['longitude'],
                    address: rest['address'],
                    url: rest['url'],
                    drink_url: '',
                    image1: rest['image_url']['shop_image1'],
                    image2: rest['image_url']['shop_image2'],
                    tel: rest['tel'],
                    opentime: rest['opentime'],
                    holiday: rest['holiday'],
                    access_line: rest['access']['line'],
                    access_station: rest['access']['station'],
                    access_station_exit: rest['access']['station_exit'],
                    access_walk: rest['access']['walk'],
                    access_note: rest['access']['note'],
                    parking_lots: rest['parking_lots'],
                    pr: rest['pr']['pr_short'],
                    budget: rest['budget'],
                    party: rest['party'],
                    lunch: rest['lunch'],
                    credit_card: rest['credit_card'],
                    e_money: rest['e_money']
                )
                stores.save
            end
            offSet += 100
        end
    end
end