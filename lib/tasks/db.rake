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

    desc "ドリンクタイプのInsertを行う"
    task :drink_type_insert => :environment do
        require 'csv'

        CSV.read('csv/drink_type1.csv', headers: false).each do |row|
            drink_type = DrinkType.new(
                drink_type: row[0],
            )
            drink_type.save
        end
    end

    desc "ビール対応表のInsertを行う"
    task :beer_correspondence_insert => :environment do
        require 'csv'

        CSV.read('csv/beer_correspondence1.csv', headers: false).each do |row|
            beer_correspondence = BeerCorrespondence.new(
                beer_name: row[0],
                drink_id: row[1]
            )
            beer_correspondence.save
        end
    end
end