class HomeController < ApplicationController
  before_action :check_user_agent_for_mobile

  def top
    @shop = Shop.all.order(beer_price: "DESC")
    @beer_price = Shop.minimum(:beer_price)
  end

  def show
    @shop = Shop.find_by(id: params[:id])
  end

  private
    def check_user_agent_for_mobile
      if request.from_smartphone?
        request.variant = :mobile
      end
    end
end
