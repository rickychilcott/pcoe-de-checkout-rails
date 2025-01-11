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

ActiveRecord::Schema[7.2].define(version: 2025_01_10_211537) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.integer "actor_id"
    t.integer "facilitator_id", null: false
    t.string "action", null: false
    t.json "extra", default: {}, null: false
    t.datetime "occurred_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "record_gids", default: [], null: false
    t.index ["action"], name: "index_activities_on_action"
    t.index ["actor_id"], name: "index_activities_on_actor_id"
    t.index ["facilitator_id"], name: "index_activities_on_facilitator_id"
    t.index ["record_gids"], name: "index_activities_on_record_gids"
  end

  create_table "admin_user_groups", force: :cascade do |t|
    t.integer "admin_user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_admin_user_groups_on_admin_user_id"
    t.index ["group_id"], name: "index_admin_user_groups_on_group_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "super_admin", default: false, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "customer_id", null: false
    t.integer "checked_out_by_id", null: false
    t.datetime "checked_out_at"
    t.datetime "returned_at"
    t.integer "returned_by_id"
    t.date "expected_return_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checked_out_by_id"], name: "index_checkouts_on_checked_out_by_id"
    t.index ["customer_id"], name: "index_checkouts_on_customer_id"
    t.index ["item_id"], name: "index_checkouts_on_item_id"
    t.index ["returned_by_id"], name: "index_checkouts_on_returned_by_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "ohio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pid", null: false
    t.string "role", default: "student", null: false
    t.index ["ohio_id"], name: "index_customers_on_ohio_id", unique: true
    t.index ["pid"], name: "index_customers_on_pid", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "serial_number"
    t.integer "parent_item_id"
    t.integer "location_id"
    t.string "qr_code_identifier"
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_items_on_ancestry"
    t.index ["group_id"], name: "index_items_on_group_id"
    t.index ["location_id"], name: "index_items_on_location_id"
    t.index ["parent_item_id"], name: "index_items_on_parent_item_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "admin_users", column: "facilitator_id"
  add_foreign_key "activities", "customers", column: "actor_id"
  add_foreign_key "admin_user_groups", "admin_users"
  add_foreign_key "admin_user_groups", "groups"
  add_foreign_key "checkouts", "admin_users", column: "checked_out_by_id"
  add_foreign_key "checkouts", "admin_users", column: "returned_by_id"
  add_foreign_key "checkouts", "customers"
  add_foreign_key "checkouts", "items"
  add_foreign_key "items", "groups"
  add_foreign_key "items", "items", column: "parent_item_id"
  add_foreign_key "items", "locations"
end
