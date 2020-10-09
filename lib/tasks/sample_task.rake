namespace :sample_task do
    desc "DBにデータを保存するタスクです"
    task :pick_new_data => :environment do

        require 'net/http'
        require 'uri'
        require 'json'

        KEY_ID = '8c3588ed9e7efdb4b8aabb5d5768ee82'
        AREA_CODE_S = 'AREAS2288'
        HIT_PER_PAGE = '2'

        url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&hit_per_page=#{HIT_PER_PAGE}"

        uri = URI.parse(url)
        json = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
        result = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換

        for i in 0..1 do
            shop = Shop.new(
                name: result["rest"][i]["name"],
                average: result["rest"][i]["budget"],
                beer_price: 500,
                distance: "徒歩" + result["rest"][i]["access"]["walk"] + "分",
                content: result["rest"][i]["pr"]["pr_short"],
                url: result["rest"][i]["url"],
                image: result["rest"][i]["image_url"]["shop_image1"]
            )
            shop.save
        end
    end

    desc "CSV読み込み"
    task :readcsv => :environment do
        require 'csv'
        drink = Drink.new(
            name: "hoge",
            type: 1
        )
        drink.save
    end

    desc "DBの内容を削除するタスクです"
    task :destroy_data => :environment do
        shop = Shop.all
        if shop.delete_all
            puts "削除できました"
        else
            puts "削除できてません"
        end
    end

    desc "apiの返り値確認"
    task :test_api => :environment do
        require 'net/http'
        require 'uri'
        require 'json'

        KEY_ID = '8c3588ed9e7efdb4b8aabb5d5768ee82'
        AREA_CODE_S = 'AREAS2288'
        HIT_PER_PAGE = '1'

        url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&hit_per_page=#{HIT_PER_PAGE}"

        uri = URI.parse(url)
        json = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
        result = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
        puts result
    end

    desc "csvファイルの作成テスト"
    task :make_csv do
        require 'csv'

        CSV.open('test.csv','w') do |test|

            header = %w(id name average create_at apdate_at)
            test << header

            shops.each do |shop|
            values = [shop.id, shop.name, shop.average, shop.created_at, shop.updated_at]
            test << values
            end
        end
    end

    desc "ぐるなびAPI"
    task :gurunabi do
        require 'net/http'
        require 'uri'
        require 'json'
        require "open-uri"
        require "nokogiri"
        require "csv"

        #----------------- ぐるなびAPI -----------------#

        KEY_ID       = '8c3588ed9e7efdb4b8aabb5d5768ee82'
        AREA_CODE_S  = 'AREAS2288'
        HIT_PER_PAGE = '10'

        API_URL = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&hit_per_page=#{HIT_PER_PAGE}"

        uri    = URI.parse(API_URL)
        json   = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
        result = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
        name   = [] # 店舗名
        ids    = [] # 店舗ID
        urls   = [] # 店舗URL

        result['rest'].each do |rest|
            name << rest['name']
            ids  << rest["id"]
            urls << rest['url']
        end

        #----------------- ここまで -----------------#
        #----------------- スクレイピング -----------------#

        drink_urls = [] # ドリンクURL
        ids.each do |id|
            drink_urls << 'https://r.gnavi.co.jp/' + id + '/drink'
        end

        items  = []
        drinks = []

        drink_urls.each do |url|
            doc = Nokogiri::HTML(open(url),nil,"utf-8")
            menu = doc.css('.menu')

            # メニューアイテム
            menu.css('.menu-item').each do |link|
                items << link
            end

            items.each do |item|
                name = item.css('.menu-term').inner_text.scan(/\S+/)
                getPrice = item.css('.menu-price').inner_text.scan(/\d[,\d]\d+/)
                price = []

                getPrice.each do |children|
                    price << children.sub(',', '_').to_i
                end

                drinks << {
                    "url"   => url,
                    "name"  => name,
                    "price" => price,
                }
            end
        end
        #----------------- ここまで -----------------#
        #----------------- CSV -----------------#

        CSV.open('test.csv','w') do |item|
            header = %w(name url drink price)
            item << header

            drinks.each do |drink|
                values = [drink["url"], drink["name"], drink["price"]]
                item << values
            end
        end

        #----------------- ここまで -----------------#
    end
end
