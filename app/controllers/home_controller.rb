class HomeController < ApplicationController
  def top
    @top3 = 1
    @shop = Shop.all.order(beer_price: "DESC")
    @beer_price = Shop.minimum(:beer_price)
  end
end
