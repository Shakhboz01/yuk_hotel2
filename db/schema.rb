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

ActiveRecord::Schema[7.0].define(version: 2024_01_08_090210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.integer "number_of_people"
    t.datetime "finished_at"
    t.boolean "breakfast_included", default: true
    t.bigint "home_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["home_id"], name: "index_bookings_on_home_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.string "comment"
    t.bigint "user_id", null: false
    t.integer "price"
    t.integer "expenditure_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_expenditures_on_user_id"
  end

  create_table "guest_infos", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "name"
    t.string "phone_number"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country", default: ""
    t.boolean "avtive_guest", default: true
    t.index ["booking_id"], name: "index_guest_infos_on_booking_id"
  end

  create_table "homes", force: :cascade do |t|
    t.integer "number"
    t.string "comment"
    t.integer "number_of_people"
    t.integer "home_type"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "closed_at"
    t.decimal "total_income"
    t.decimal "total_expenditure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "top_ups", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.decimal "price"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guest_info_id", null: false
    t.integer "payment_type", default: 0
    t.index ["booking_id"], name: "index_top_ups_on_booking_id"
    t.index ["guest_info_id"], name: "index_top_ups_on_guest_info_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 2
    t.string "name"
    t.boolean "active", default: true
    t.boolean "allowed_to_use", default: true
    t.integer "daily_payment", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "homes"
  add_foreign_key "expenditures", "users"
  add_foreign_key "guest_infos", "bookings"
  add_foreign_key "participations", "users"
  add_foreign_key "shifts", "users"
  add_foreign_key "top_ups", "bookings"
  add_foreign_key "top_ups", "guest_infos"
end
