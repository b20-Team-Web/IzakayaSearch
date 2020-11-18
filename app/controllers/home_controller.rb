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

    sql_column = []
    sql_query = ""
    @title = "八王子駅周辺で最も"

    if params[:beer].present?
      sql_column << "drink_price"
      @title << "ビール価格と"
    end

    if params[:budget].present?
      sql_column << " budget"
      @title << "平均価格"
    else
      @title.chop!
    end

    if sql_column.present?
      sql_column.each do |column|
        sql_query << column << ","
      end
      sql_query.chop!
    else
      sql_query = "drink_price"
    end

    @title << "が安い順"
    sql_test = "select drink_prices.store_code, stores.name as store_name, image1, access_line, access_station, access_station_exit, access_walk, pr, budget, drink_price, drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) ORDER BY #{sql_query};"
    @sql_test = "select drink_prices.store_code, stores.name as store_name, image1, access_line, access_station, access_station_exit, access_walk, pr, budget, drink_price, drinks.name as drink_name from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id INNER JOIN stores ON drink_prices.store_code = stores.code where drink_prices.id in(select min(drink_prices.id) from drink_prices INNER JOIN drinks ON drink_prices.drink_id = drinks.id group by store_code, drinks.name) ORDER BY #{sql_query};"
    store_test = ActiveRecord::Base.connection.select_all(sql_test).to_hash
    @test_data = store_test.group_by{|s|s["store_code"]}.map{|k,ary|a0=ary.first.dup;a0["drink_name"]=[]; a0["drink_price"]=ary.map{|a| a["drink_price"]}.min; ary.inject(a0){|a,s| a["drink_name"] << s["drink_name"];a}}
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
