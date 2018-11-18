# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_17_145450) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 4, null: false
    t.index ["code"], name: "index_companies_on_code", unique: true
  end

  create_table "data", force: :cascade do |t|
    t.integer "row_index", null: false
    t.integer "column_index", null: false
    t.decimal "amount", null: false
    t.bigint "statement_id"
    t.bigint "year_id"
    t.bigint "quarter_id"
    t.bigint "company_id"
    t.bigint "page_id"
    t.index ["company_id"], name: "index_data_on_company_id"
    t.index ["page_id"], name: "index_data_on_page_id"
    t.index ["quarter_id"], name: "index_data_on_quarter_id"
    t.index ["statement_id"], name: "index_data_on_statement_id"
    t.index ["year_id"], name: "index_data_on_year_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 4, null: false
  end

  create_table "quarters", force: :cascade do |t|
    t.string "quarter", limit: 1, null: false
    t.index ["quarter"], name: "index_quarters_on_quarter", unique: true
  end

  create_table "statements", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 2
    t.index ["code"], name: "index_statements_on_code", unique: true
  end

  create_table "year_quarters", force: :cascade do |t|
    t.bigint "year_id", null: false
    t.bigint "quarter_id", null: false
    t.index ["quarter_id"], name: "index_year_quarters_on_quarter_id"
    t.index ["year_id", "quarter_id"], name: "index_year_quarters_on_year_id_and_quarter_id", unique: true
    t.index ["year_id"], name: "index_year_quarters_on_year_id"
  end

  create_table "years", force: :cascade do |t|
    t.string "year", limit: 2, null: false
    t.index ["year"], name: "index_years_on_year", unique: true
  end

  add_foreign_key "data", "companies"
  add_foreign_key "data", "pages"
  add_foreign_key "data", "quarters"
  add_foreign_key "data", "statements"
  add_foreign_key "data", "years"
  add_foreign_key "year_quarters", "quarters"
  add_foreign_key "year_quarters", "years"
end
