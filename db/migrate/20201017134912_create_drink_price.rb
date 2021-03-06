class CreateDrinkPrice < ActiveRecord::Migration[6.0]
  def change
    # 詳細は https://docs.google.com/spreadsheets/d/1onE2jPOAw3P_wLcys3GU-qna4_eBZ0ulOxbwNqIjitw/edit#gid=274071177 を参照
    create_table :drink_prices do |t|
      t.string :store_code, null: false
      t.references :drink, foreign_key: true
      t.integer :drink_price, null: false
    end
  end
end
