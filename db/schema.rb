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

ActiveRecord::Schema[7.0].define(version: 2023_04_17_123952) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "quantity"
    t.bigint "waste_paper_proportion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_billets_on_user_id"
    t.index ["waste_paper_proportion_id"], name: "index_billets_on_waste_paper_proportion_id"
  end

  create_table "books", force: :cascade do |t|
    t.integer "sold"
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "end_products", force: :cascade do |t|
    t.integer "amount_left"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenditures", force: :cascade do |t|
    t.bigint "executor_id"
    t.string "comment"
    t.bigint "user_id"
    t.bigint "product_id"
    t.bigint "outcomer_id"
    t.integer "expenditure_type"
    t.integer "price"
    t.integer "quantity"
    t.integer "total_paid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outcomer_id"], name: "index_expenditures_on_outcomer_id"
    t.index ["product_id"], name: "index_expenditures_on_product_id"
    t.index ["user_id"], name: "index_expenditures_on_user_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.integer "income_type", default: 0
    t.bigint "product_id"
    t.integer "quantity", default: 0
    t.bigint "outcomer_id", null: false
    t.integer "price", default: 0
    t.integer "total_paid", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outcomer_id"], name: "index_incomes_on_outcomer_id"
    t.index ["product_id"], name: "index_incomes_on_product_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "machine_sizes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "devision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_machine_sizes_on_user_id"
  end

  create_table "outcomers", force: :cascade do |t|
    t.integer "role"
    t.string "name"
    t.boolean "active_outcomer", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packages", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_packages_on_product_id"
    t.index ["user_id"], name: "index_packages_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "product_prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "amount_left"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "proportion_details", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "waste_paper_proportion_id", null: false
    t.integer "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_proportion_details_on_product_id"
    t.index ["waste_paper_proportion_id"], name: "index_proportion_details_on_waste_paper_proportion_id"
  end

  create_table "sausages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sausages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.integer "role", default: 0
    t.boolean "active_user", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "waste_paper_proportions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "billets", "users"
  add_foreign_key "billets", "waste_paper_proportions"
  add_foreign_key "expenditures", "outcomers"
  add_foreign_key "expenditures", "products"
  add_foreign_key "expenditures", "users"
  add_foreign_key "incomes", "outcomers"
  add_foreign_key "incomes", "products"
  add_foreign_key "incomes", "users"
  add_foreign_key "machine_sizes", "users"
  add_foreign_key "packages", "products"
  add_foreign_key "packages", "users"
  add_foreign_key "participations", "users"
  add_foreign_key "product_prices", "products"
  add_foreign_key "proportion_details", "products"
  add_foreign_key "proportion_details", "waste_paper_proportions"
  add_foreign_key "sausages", "users"
end
