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
        HIT_PER_PAGE = '10'

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
        HIT_PER_PAGE = '100'

        API_URL = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&hit_per_page=#{HIT_PER_PAGE}"

        uri    = URI.parse(API_URL)
        json   = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
        result = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
        getData = []

        result['rest'].each do |rest|
            getData << {
                "id"        => rest["id"],        # 店舗ID
                "name"      => rest["name"],      # 店舗名
                "nameKana"  => rest["name_kana"], # 店舗名カナ
                "latitude"  => rest["latitude"],  # 緯度
                "longitude" => rest["longitude"], # 軽度
                "url"       => rest["url"],       # 店舗URL
                "drinkUrl"  => 'https://r.gnavi.co.jp/' + rest["id"] + '/drink', # ドリンクURL
                "address"   => rest["address"],   # 住所
                "tel"       => rest["tel"],       # 電話番号
                "imageUrl"  => rest["image_url"], # shop_image1: 画像1, shop_image2: 画像2, qrcode: QRコード
                "budget"    => rest["budget"],    # 平均予算
                "products"  => [],                # 商品
            }
        end

        #-----------------   ここまで    -----------------#
        #----------------- スクレイピング -----------------#

        getData.each do |data|
            dom = Nokogiri::HTML(open(data["drinkUrl"]),nil,"utf-8")
            menu = dom.css('.menu')

            items = []

            # メニューアイテム
            menu.css('.menu-item').each do |link|
                items << link
            end

            items.each do |item|
                productName  = item.css('.menu-term').inner_text.scan(/\S+/)
                productPrice = item.css('.menu-price').inner_text.scan(/\d[,\d]\d+/)
                price = []

                productPrice.each do |price|
                    price << price.sub(',', '_').to_i
                end
                data["products"] << {
                    "productName"  => productName,
                    "productPrice" => productPrice,
                }
            end
        end
        #----------------- ここまで -----------------#
        #----------------- CSV -----------------#

        CSV.open('test.csv','w') do |item|
            header = %w(店舗ID 店舗名 店舗名カナ 緯度 軽度 店舗URL ドリンクURL 住所 電話番号 平均予算 商品)
            item << header

            getData.each do |data|
                values = [
                    data["id"],
                    data["name"],
                    data["nameKana"],
                    data["latitude"],
                    data["longitude"],
                    data["url"],
                    data["drinkUrl"],
                    data["address"],
                    data["tel"],
                    data["budget"],
                    data["products"],
                ]

                    item << values
            end
        end

        #----------------- ここまで -----------------#
    end
end
