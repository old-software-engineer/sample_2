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

ActiveRecord::Schema.define(version: 20170508064144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "booking_item_stocks", force: :cascade do |t|
    t.integer  "booking_id",    null: false
    t.integer  "item_stock_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["booking_id"], name: "index_booking_item_stocks_on_booking_id", using: :btree
    t.index ["item_stock_id"], name: "index_booking_item_stocks_on_item_stock_id", unique: true, using: :btree
  end

  create_table "booking_items", force: :cascade do |t|
    t.integer  "item_id",                      null: false
    t.integer  "booking_id",                   null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "quantity_ordered", default: 0
    t.index ["booking_id"], name: "index_booking_items_on_booking_id", using: :btree
    t.index ["item_id", "booking_id"], name: "index_booking_items_on_item_id_and_booking_id", unique: true, using: :btree
    t.index ["item_id"], name: "index_booking_items_on_item_id", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "user_id",                                     null: false
    t.string   "address",                                     null: false
    t.integer  "booking_type",                default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "contact_name",     limit: 50, default: ""
    t.string   "contact_phone",    limit: 20, default: ""
    t.boolean  "read",                        default: false
    t.integer  "status",                      default: 0
    t.text     "comment",                     default: ""
    t.string   "city",                        default: ""
    t.string   "suburb",                      default: ""
    t.string   "state",                       default: ""
    t.string   "country",                     default: ""
    t.string   "tracking_id",                 default: ""
    t.string   "reference",                   default: ""
    t.string   "email",                       default: ""
    t.string   "parcel_dimension",            default: ""
    t.string   "parcel_type",                 default: ""
    t.index ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.string   "address",                            null: false
    t.string   "phone",      limit: 20,              null: false
    t.string   "first_name", limit: 50,              null: false
    t.string   "last_name",  limit: 50,              null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "suburb",                default: ""
    t.string   "city",                  default: ""
    t.string   "state",                 default: ""
    t.string   "country",               default: ""
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.float    "space_usage",  default: 0.0
    t.integer  "num_items",    default: 0
    t.datetime "invoice_date"
    t.boolean  "paid",         default: false
    t.string   "pdf_url"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_invoices_on_user_id", using: :btree
  end

  create_table "item_location_histories", force: :cascade do |t|
    t.integer  "location_id", null: false
    t.integer  "item_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["item_id"], name: "index_item_location_histories_on_item_id", using: :btree
    t.index ["location_id"], name: "index_item_location_histories_on_location_id", using: :btree
  end

  create_table "item_shares", force: :cascade do |t|
    t.integer  "item_id",            null: false
    t.integer  "secondary_owner_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["item_id", "secondary_owner_id"], name: "index_item_shares_on_item_id_and_secondary_owner_id", unique: true, using: :btree
    t.index ["item_id"], name: "index_item_shares_on_item_id", using: :btree
    t.index ["secondary_owner_id"], name: "index_item_shares_on_secondary_owner_id", using: :btree
  end

  create_table "item_stocks", force: :cascade do |t|
    t.integer  "item_id",                          null: false
    t.integer  "quantity_diff",       default: 0
    t.integer  "quantity_in_storage", default: 0
    t.integer  "adjustment_type",     default: 0
    t.text     "description",         default: "", null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["item_id"], name: "index_item_stocks_on_item_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "image",       default: "",  null: false
    t.string   "physical_id", default: "",  null: false
    t.string   "string",      default: "",  null: false
    t.string   "title",       default: "",  null: false
    t.text     "description", default: "",  null: false
    t.float    "volume",      default: 0.0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "location_id"
    t.string   "sku",         default: ""
    t.float    "weight",      default: 0.0
    t.float    "height",      default: 0.0
    t.float    "width",       default: 0.0
    t.float    "length",      default: 0.0
    t.index ["location_id"], name: "index_items_on_location_id", using: :btree
    t.index ["user_id"], name: "index_items_on_user_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "warehouse_id",              null: false
    t.string   "row",          default: ""
    t.string   "bay",          default: ""
    t.string   "height",       default: ""
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["warehouse_id", "row", "bay", "height"], name: "index_locations_on_warehouse_id_and_row_and_bay_and_height", unique: true, using: :btree
    t.index ["warehouse_id"], name: "index_locations_on_warehouse_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "active",                 default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "warehouses", force: :cascade do |t|
    t.string   "address_1",   limit: 100, default: ""
    t.string   "address_2",   limit: 100, default: ""
    t.string   "suburb",      limit: 100, default: ""
    t.string   "postal_code", limit: 100, default: ""
    t.integer  "state",                   default: 0
    t.integer  "capacity",                default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_foreign_key "booking_item_stocks", "bookings"
  add_foreign_key "booking_item_stocks", "item_stocks", on_delete: :cascade
  add_foreign_key "booking_items", "bookings"
  add_foreign_key "booking_items", "items"
  add_foreign_key "bookings", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "invoices", "users"
  add_foreign_key "item_location_histories", "items"
  add_foreign_key "item_location_histories", "locations"
  add_foreign_key "item_shares", "items"
  add_foreign_key "item_shares", "users", column: "secondary_owner_id"
  add_foreign_key "item_stocks", "items", on_delete: :cascade
  add_foreign_key "items", "locations"
  add_foreign_key "items", "users"
  add_foreign_key "locations", "warehouses"
end
