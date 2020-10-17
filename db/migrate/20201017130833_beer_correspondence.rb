class BeerCorrespondence < ActiveRecord::Migration[6.0]
  def change
    # 詳細は https://docs.google.com/spreadsheets/d/1onE2jPOAw3P_wLcys3GU-qna4_eBZ0ulOxbwNqIjitw/edit#gid=274071177 を参照
    create_table :beer_correspondence do |t|
      t.string  :beer_name
      t.integer :drink_id
    end
  end
end
