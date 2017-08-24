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


ActiveRecord::Schema.define(version: 20170824131319) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"


  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_comments_on_event_id"

  create_table "balance_days", force: :cascade do |t|
    t.datetime "day"
    t.integer "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

  end

  create_table "events", force: :cascade do |t|
    t.bigint "lease_id"
    t.datetime "start_date"
    t.datetime "urgent_date"
    t.datetime "end_date"
    t.string "status"
    t.string "emergency_level"
    t.boolean "to_do"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["lease_id"], name: "index_events_on_lease_id"
  end

  create_table "leases", force: :cascade do |t|
    t.bigint "user_id"
    t.string "tenant_name"
    t.string "tenant_address"
    t.integer "num_lot"
    t.string "owner_name"
    t.string "owner_address"
    t.string "owner_email"
    t.integer "monthly_rent"
    t.integer "rent_balance"
    t.integer "overdue_days"
    t.datetime "next_revision"
    t.datetime "end_date"
    t.string "nature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tenant_first_name"
    t.string "tenant_gender"
    t.string "tenant_company"
    t.index ["user_id"], name: "index_leases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "events"
  add_foreign_key "events", "leases"
  add_foreign_key "leases", "users"
end
