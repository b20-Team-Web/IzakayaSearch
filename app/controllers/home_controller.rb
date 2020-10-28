class HomeController < ApplicationController
  before_action :check_user_agent_for_mobile

  def top
    #とってる情報はcode name access_station access_station_exit access_walk budget pr drink_id min(drink_price)
    sql = "select stores.code, name, access_station, access_station_exit, access_walk, budget, pr, drink_id, min(drink_price) from stores INNER JOIN drink_prices ON drink_prices.store_code = stores.code GROUP BY stores.code ORDER BY min(drink_price) asc;"
    @store_data = ActiveRecord::Base.connection.select_all(sql).to_hash
    
    sql = "select store_code, name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name);"
    @drink_name = ActiveRecord::Base.connection.select_all(sql).to_hash

    sql = "select drink_prices.store_code, stores.name as store_name, image1, access_station_exit, access_walk, pr, budget, drink_price, drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) ORDER BY drink_price ASC;"
    @store = ActiveRecord::Base.connection.select_all(sql).to_hash

    #@h = [{"first" => "a", "name" => ["b","c","d"]}, {"first" => "b", "name" => ["e","f","g"]}]
    
    #@drink_data = @drink_name.group_by{|h| h["store_code"]}.map{|k,a| [k,a.map{|h| h["name"]}]}.to_h
  
    #@stores_data = @store.group_by{|h| h["store_code"]}.map{|n,a| [n,a.map{|h| h["name"]}]}

    #@stores_data = @store.group_by{|s| s["store_code"]}.map{|k,ary| a0=ary.first.dup;a0["drink_name"] = [];a0["drink_price"]=ary.map{|a| a["drink_price"]}.min; ary.inject(a0){|a,s| a["drink_name"]=[a["drink_name"], s["drink_name"]].flatten;a}}
    
    @stores_data = @store.group_by{|s|s["store_code"]}.map{|k,ary|a0=ary.first.dup;a0["drink_name"]=[]; a0["drink_price"]=ary.map{|a| a["drink_price"]}.min; ary.inject(a0){|a,s| a["drink_name"] << s["drink_name"];a}}
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

# select DISTINCT drinks.id, drink_orices.stores_code, name, drink_price
# from
#   drink_prices INNER JOIN drinks ON
#     drink_prices.drink_id = drinks.id;

#select drink_prices.store_code, stores.name as store_name, image1, access_station_exit, access_walk, pr, budget, drink_price, drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name);