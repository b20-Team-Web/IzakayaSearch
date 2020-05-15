class HomeController < ApplicationController
  def top
    @shop = Shop.all.order(beer_price: "DESC")
    @beer_price = Shop.minimum(:beer_price)
  end

  def show
    @shop = Shop.find_by(id: params[:id])
  end
end
