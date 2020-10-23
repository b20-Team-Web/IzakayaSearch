class HomeController < ApplicationController
  before_action :check_user_agent_for_mobile

  def top
    sql = "select stores.store_id, drink_id, min(drink_price) from stores INNER JOIN drink_prices ON drink_prices.store_id = stores.store_id GROUP BY stores.store_id ORDER BY min(drink_price) asc;"
    @store_data = ActiveRecord::Base.connection.select_all(sql).to_hash
    
  end

  def show
    #@shop = Shop.find_by(id: params[:id])
  end

  private
    def check_user_agent_for_mobile
      if request.from_smartphone?
        request.variant = :mobile
      end
    end
end
