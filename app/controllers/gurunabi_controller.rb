# ぐるなび詳細ページのクローラー
class GurunabiController < ApplicationController
    require "open-uri"
    require "nokogiri"

    def index
        uri = "https://r.gnavi.co.jp/getz305/menu3/"
        @doc = Nokogiri::HTML(open(uri),nil,"utf-8")
        @drinks = []
        @beers  = []
        @prices = []


    ## ドリンクの取得
    @doc.css("li/dl/dt", ".menu-term .cx/.menu-term").each do |link|
        if link.text.include?("◇") != true && link.text.include?("◆") != true
            @drinks << link.inner_text
        end
    end

    ## ビールの取得
    @doc.css(".menu-list").each do |link|
        @beers << link.inner_text
    end

    # @beers = @doc.xpath('')

    ## 価格の取得
    @doc.css("li/dl/dd/table/tbody/tr/td", ".menu-price").each do |link|
        if link.text.include?("円") && link.text.include?("♪") != true
            @prices << link.inner_text
        end
    end
    end
end
