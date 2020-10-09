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

ActiveRecord::Schema.define(version: 2020_10_09_042926) do

  create_table "drink_type", force: :cascade do |t|
    t.string "type"
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name"
    t.integer "drink_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.integer "average"
    t.integer "beer_price"
    t.string "distance"
    t.string "content"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
  end

  create_table "store_drink_price", force: :cascade do |t|
    t.integer "store_id"
    t.integer "drink_id"
    t.integer "drink_price"
  end

  create_table "stores_info", force: :cascade do |t|
    t.string "name"
    t.string "name_ruby"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "image1"
    t.string "image2"
    t.string "store_url"
    t.string "drink_url"
    t.integer "phone"
    t.integer "is_reservation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
