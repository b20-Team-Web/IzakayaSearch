namespace :db do
    desc "ビールメニューのInsertを行う"
    task :drink_beer_insert => :environment do
        require 'csv'

        CSV.read('csv/beer_drinks1.csv', headers: false).each do |row|
            drink = Drink.new(
                name: row[0],
                drink_type: 1
            )
            drink.save
        end
    end
end