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

ActiveRecord::Schema[7.1].define(version: 2024_01_29_121934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blacklisted_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_blacklisted_tokens_on_token"
  end

  create_table "hole_details", force: :cascade do |t|
    t.json "csv_data"
    t.string "hole_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holes", primary_key: "hole_id", id: :string, force: :cascade do |t|
    t.integer "hole_name"
    t.float "start_point_x"
    t.float "start_point_y"
    t.float "start_point_z"
    t.float "end_point_x"
    t.float "end_point_y"
    t.float "end_point_z"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
