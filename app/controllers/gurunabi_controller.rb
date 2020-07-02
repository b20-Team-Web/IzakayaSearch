# ぐるなび詳細ページのクローラー
class GurunabiController < ApplicationController
    require "open-uri"
    require "nokogiri"

    def index
        uri       = "https://r.gnavi.co.jp/b676801/menu5/"
        @doc      = Nokogiri::HTML(open(uri),nil,"utf-8")
        @items    = []
        @drinks   = []

        menu = @doc.css('.menu')

        # メニューアイテム
        menu.css('.menu-item').each do |link|
            @items << link
        end

        # 各メニュー情報の取得
        @items.each do |item|
            name = item.css('.menu-term').inner_text
            getPrice = item.css('.menu-price').inner_text.scan(/\d[,\d]\d+/)
            price = []

            getPrice.each do |children|
                price << children.sub(',', '_').to_i
            end

            @drinks << {
                "name"  => name,
                "price" => price,
            }
        end

    end
end
