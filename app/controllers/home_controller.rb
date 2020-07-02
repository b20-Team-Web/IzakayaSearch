class HomeController < ApplicationController
  def top
    @shop = Shop.all.order(beer_price: "DESC")
    @beer_price = Shop.minimum(:beer_price)
  end

  def show
    @shop = Shop.find_by(id: params[:id])
  end

  require "csv"
  def csv
    CSV.open('test.csv','w') do |test|
      shops = Shop.all

      header = %w(id name average create_at apdate_at)
      csv << header

      shops.each do |shop|
        values = [shop.id, shop.name, shop.average, shop.created_at, shop.updated_at]
        csv << values
      end
    end
  end
end
