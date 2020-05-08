class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.integer :average
      t.integer :beer_price
      t.string :distance
      t.string :content
      t.string :url

      t.timestamps
    end
  end
end
