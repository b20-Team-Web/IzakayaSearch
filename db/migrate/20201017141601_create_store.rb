class CreateStore < ActiveRecord::Migration[6.0]
  def change
    # 詳細は https://docs.google.com/spreadsheets/d/1onE2jPOAw3P_wLcys3GU-qna4_eBZ0ulOxbwNqIjitw/edit#gid=274071177 を参照
    create_table :stores do |t|
      t.string   :code, null: false
      t.string   :name
      t.string   :name_kana
      t.float    :latitude
      t.float    :longitude
      t.string   :address
      t.string   :url
      t.string   :drink_url
      t.string   :image1
      t.string   :image2
      t.string   :tel
      t.string   :opentime
      t.string   :holiday
      t.string   :access_line
      t.string   :access_station
      t.string   :access_station_exit
      t.integer  :access_walk
      t.string   :access_note
      t.integer  :parking_lots
      t.string   :pr
      t.integer  :budget
      t.integer  :party
      t.integer  :lunch
      t.string   :credit_card
      t.string   :e_money
    end
  end
end
