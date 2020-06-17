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
        HIT_PER_PAGE = '1'

        url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&hit_per_page=#{HIT_PER_PAGE}"

        uri = URI.parse(url)
        json = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
        result = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
        puts result
    end
end