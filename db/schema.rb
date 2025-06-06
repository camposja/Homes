# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_20_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", id: :serial, force: :cascade do |t|
    t.integer "home_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["home_id"], name: "index_favorites_on_home_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "files", id: :serial, force: :cascade do |t|
    t.binary "content"
    t.text "metadata"
  end

  create_table "homes", id: :serial, force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.integer "bedrooms"
    t.integer "baths"
    t.integer "square_feet"
    t.integer "price"
    t.string "description"
    t.text "image_data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "provider"
    t.string "uid"
    t.string "nickname"
    t.string "access_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "favorites", "homes"
  add_foreign_key "favorites", "users"
end
