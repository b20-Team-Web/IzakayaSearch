class HomeController < ApplicationController
  def top
    @shop = Shop.all.order(beer_price: "DESC")
    @beer_price = Shop.minimum(:beer_price)
  end

  def show
    @shop = Shop.find_by(id: params[:id])
  end

  def csv
    respond_to do |format|
      format.html
      format.csv do |csv|

        shops = Shop.all

        csv_data = CSV.generate do |csv|
          header = %w(id name average create_at apdate_at)
          csv << header

          shops.each do |shop|
            values = [shop.id, shop.name, shop.average, shop.create_at, shop.update_at]
            csv << values
          end
        end
        send_data(csv_data, filename: "shops.csv")
      end
    end
  end
end
