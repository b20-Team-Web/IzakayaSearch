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

  create_table "beer_correspondences", force: :cascade do |t|
    t.string "name", null: false
    t.integer "drink_id"
    t.index ["drink_id"], name: "index_beer_correspondences_on_drink_id"
  end

  create_table "drink_prices", force: :cascade do |t|
    t.string "store_code", null: false
    t.integer "drink_id"
    t.integer "drink_price", null: false
    t.index ["drink_id"], name: "index_drink_prices_on_drink_id"
  end

  create_table "drink_types", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name", null: false
    t.integer "drink_type_id"
    t.index ["drink_type_id"], name: "index_drinks_on_drink_type_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "name_kana"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "url"
    t.string "drink_url"
    t.string "image1"
    t.string "image2"
    t.string "tel"
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

  add_foreign_key "beer_correspondences", "drinks"
  add_foreign_key "drink_prices", "drinks"
  add_foreign_key "drinks", "drink_types"
end
