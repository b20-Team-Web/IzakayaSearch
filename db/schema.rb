# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_17_141601) do

  create_table "beer_correspondence", force: :cascade do |t|
    t.string "beer_name"
    t.integer "drink_id"
  end

  create_table "drink_prices", force: :cascade do |t|
    t.integer "store_id"
    t.integer "drink_id"
    t.integer "drink_price"
  end

  create_table "drink_types", force: :cascade do |t|
    t.integer "drink_type"
  end

  create_table "drinks", force: :cascade do |t|
    t.integer "drink_id"
    t.string "name"
    t.integer "drink_type"
  end

  create_table "stores", force: :cascade do |t|
    t.integer "store_id"
    t.string "name"
    t.string "name_kana"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "url"
    t.string "drink_url"
    t.string "image1"
    t.string "image2"
    t.integer "tel"
    t.string "opentime"
    t.string "holiday"
    t.string "access_line"
    t.string "access_station"
    t.string "access_station_exit"
    t.integer "access_walk"
    t.string "access_note"
    t.integer "parking_lots"
    t.string "pr"
    t.integer "budget"
    t.integer "party"
    t.integer "lunch"
    t.string "credit_card"
    t.string "e_money"
  end

end
