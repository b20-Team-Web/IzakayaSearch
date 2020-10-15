namespace :gurunabi do
    desc "ぐるなびAPI"
    task :gurunabi do
        require 'net/http'
        require 'uri'
        require 'json'
        require "open-uri"
        require "nokogiri"
        require "csv"

        start_time = Time.now

        # APIの Key, AREACODE(八王子), 取得件数
        KEY_ID       = '8c3588ed9e7efdb4b8aabb5d5768ee82'
        AREA_CODE_S  = 'AREAS2288'
        CATEGORY_L   = 'RSFST09000'
        HIT_PER_PAGE = 100
        offSet      = 1
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
                getData << {
                    "id"        => rest["id"],        # 店舗ID
                    "name"      => rest["name"],      # 店舗名
                    "nameKana"  => rest["name_kana"], # 店舗名カナ
                    "latitude"  => rest["latitude"],  # 緯度
                    "longitude" => rest["longitude"], # 軽度
                    "url"       => rest["url"],       # 店舗URL
                    "drinkUrl"  => 'https://r.gnavi.co.jp/' + rest["id"], # ドリンクURL
                    "address"   => rest["address"],   # 住所
                    "tel"       => rest["tel"],       # 電話番号
                    "imageUrl"  => rest["image_url"], # shop_image1: 画像1, shop_image2: 画像2, qrcode: QRコード
                    "budget"    => rest["budget"],    # 平均予算
                    "products"  => [],                # 商品
                }
            end
            offSet += 100
        end

        get_api_time  = Time.now - start_time
        done_api_time = Time.now
        #-----------------   ここまで    -----------------#

        # items があるかの判定する関数
        def IsItems(data, drinkUrl)
            sleep(1) # アクセス数を抑えるため１秒スリープさせている
            dom = Nokogiri::HTML(URI.open(drinkUrl),nil,"utf-8")
            menu = dom.css('.menu')

            items = []

            menu.css('.menu-item').each do |link|
                items << link
            end

            if items.empty? then
                return false, ""
            else
                return true, items
            end
        end

        # スクレイピングを行う関数
        def Scraping(data, items)
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

        #----------------- スクレイピング -----------------#
        Urls = [
            '/drink',
            '/menu1',
            '/menu2',
            '/menu3',
            '/menu4',
            '/menu5',
            '/menu6',
            '/menu7',
            '/menu8',
            '/menu9',
            '/menu10',
        ]

        failure_num = 0
        break_flag  = false
        total_scraping_count = 0

        get_data_count = 0

        getData.each do |data|
            get_data_count += 1
            Urls.each do |url|
                flag, items = IsItems(data, data["drinkUrl"] + url)
                if flag === true
                    Scraping(data, items)
                    if data["products"].length <= 9
                        puts data["products"].length
                        puts "足りないので次行きまーす！！！"
                        next
                    end
                    puts "SUCCESS"
                    data["drinkUrl"] += url
                    puts data["drinkUrl"]
                    total_scraping_count += 1
                    if total_scraping_count % 10 == 0
                        puts "SUCCESS途中経過 : #{total_scraping_count}"
                    end
                    puts "-------------"
                    failure_num = 0
                    break
                else
                    if url === '/menu10'
                        puts "FAILURE"
                        puts data["drinkUrl"] + "はないです！！！！！！！！！！！！！！"
                        puts "-------------"
                        failure_num += 1
                        puts failure_num
                    end
                    if failure_num >= 5
                        break_flag = true
                        break
                    else
                        next
                    end
                end
            end

            if break_flag === true
                break
            end

            if get_data_count % 10 == 0
                puts "##########  #{get_data_count}  /  #{getData.length}  ##########"
            end
        end
        scraping_time      = Time.now - done_api_time
        done_scraping_time = Time.now

        #----------------- ここまで -----------------#
        #----------------- CSV -----------------#
        CSV.open('test.csv','w') do |item|
            header = %w(店舗ID 店舗名 店舗名カナ 緯度 軽度 店舗URL ドリンクURL 住所 電話番号 平均予算)
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
                ]
                item << values

                outputProductName = []
                outputProductPrice = []
                data["products"].each do |product|
                    outputProductName << product["productName"][0]

                    product["productPrice"].each_with_index do |hoge, i|
                        outputProductPrice << hoge.gsub(/[^\d+]/, '')
                        break if i == 1
                    end
                end

                item << outputProductName
                item << outputProductPrice
                item << []
            end

        end

        total_failure_count = getData.length - total_scraping_count
        total_time = Time.now - start_time
        puts ""
        puts "-------------------- RESULT --------------------"
        puts "|  成功した件数         : #{total_scraping_count}件"
        puts "|  失敗した件数         : #{total_failure_count}件"
        puts "|  API-Time           : #{get_api_time.floor}s"
        puts "|  Scraping-Time      : #{scraping_time.floor}s"
        puts "|  Total-Time         : #{total_time.floor}s"
    end

    desc "店舗数取得API"
    task :totalHitCount do
        require 'net/http'
        require 'uri'
        require 'json'
        require "open-uri"
        require "nokogiri"
        require "csv"

        #----------------- ぐるなびAPI -----------------#

        start_time = Time.now

        # APIの Key, AREACODE(八王子), 取得件数
        KEY_ID       = '8c3588ed9e7efdb4b8aabb5d5768ee82'
        AREA_CODE_S  = 'AREAS2288'
        CATEGORY_L = 'RSFST09000'
        HIT_PER_PAGE = '100'

        API_URL = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=#{KEY_ID}&areacode_s=#{AREA_CODE_S}&category_l=#{CATEGORY_L}&hit_per_page=#{HIT_PER_PAGE}"

        uri      = URI.parse(API_URL)
        json     = Net::HTTP.get(uri) #NET::HTTPを利用してAPIを叩く
        result   = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換

        puts result['total_hit_count']
        time = Time.now - start_time
        puts "処理時間 : #{time.floor}s"
    end

    desc "スプレッドシート読み込み"
    task :spredsheet do
        require 'google_drive'

    end

    desc 'CSV読み込み'
    task :readcsv => :environment do
        require 'csv'

        test = Drink.new(
            name: 'hoge',
            drink_type: 1,
        )
        test.save
    end

    desc 'メニュー取得'
    task :getMenu do
        require 'csv'
        drink_urls = []
        count        = 0

        CSV.read('/Users/sugiyamajoufutoshi/Downloads/test - test12.csv', headers: false).each do |row|
            drink_urls << row[6]
        end

        # メニューのみスクレイピングする関数
        def ScrapingMenu(items, get_menus)
            items.each do |item|
                productName  = item.css('.menu-term').inner_text.scan(/\S+/)
                puts productName
                get_menus << productName
            end
        end

        # items があるかの判定する関数
        def IsItems(url)
            sleep(1) # アクセス数を抑えるため１秒スリープさせている
            dom = Nokogiri::HTML(URI.open(url),nil,"utf-8")
            menu = dom.css('.menu')

            items = []

            menu.css('.menu-item').each do |link|
                items << link
            end

            return items
        end

        get_menus = []

        drink_urls.each do |url|
            count += 1
            puts count
            items = IsItems(url)
            ScrapingMenu(items, get_menus)
            puts '--------------'
        end
        puts get_menus

        CSV.open('./getOnlyMenu.csv','w') do |item|
            header = %w(商品名)
            item << header

            get_menus.each do |menu|
                item << menu
            end
        end
    end
end