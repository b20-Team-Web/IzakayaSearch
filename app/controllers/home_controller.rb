class HomeController < ApplicationController
  before_action :check_user_agent_for_mobile

  def top
    if !params[:jssort].present?
      sql = "select drink_prices.store_code, stores.name as store_name, image1, access_line, access_station, access_station_exit, access_walk, pr, budget, drink_price, drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) ORDER BY drink_price ASC;"
      @store = ActiveRecord::Base.connection.select_all(sql).to_hash
      @stores_data = @store.group_by{|s|s["store_code"]}.map{|k,ary|a0=ary.first.dup;a0["drink_name"]=[]; a0["drink_price"]=ary.map{|a| a["drink_price"]}.min; ary.inject(a0){|a,s| a["drink_name"] << s["drink_name"];a}}
      @h2_title = "ビールが安い順"
    else
      sql = "select drink_prices.store_code, stores.name as store_name, image1, access_line, access_station, access_station_exit, access_walk, pr, budget, drink_price, drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) ORDER BY budget, drink_price;"
      @store = ActiveRecord::Base.connection.select_all(sql).to_hash
      @stores_data = @store.group_by{|s|s["store_code"]}.map{|k,ary|a0=ary.first.dup;a0["drink_name"]=[]; a0["drink_price"]=ary.map{|a| a["drink_price"]}.min; ary.inject(a0){|a,s| a["drink_name"] << s["drink_name"];a}}
      @h2_title = "平均予算が安い順"
    end
  end

  def show
    sql = "select drink_prices.store_code, stores.name as store_name, image1, image2, latitude, longitude, address, url, tel, opentime, access_line, access_station, access_station_exit, access_walk, pr, budget, min(drink_price), drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) AND stores.code = \"#{params[:id]}\";"
    @store = ActiveRecord::Base.connection.select_all(sql).to_hash

    sql = "select drink_price as price, drinks.name as name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) AND stores.code = \"#{params[:id]}\";"
    @drink = ActiveRecord::Base.connection.select_all(sql).to_hash

    sql = "select drink_prices.store_code, stores.name as store_name, min(drink_price), drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) AND stores.code = \"#{params[:id]}\";"
  end

  private
    def check_user_agent_for_mobile
      if request.from_smartphone?
        request.variant = :mobile
      end
    end
end
