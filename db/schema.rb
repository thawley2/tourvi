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

ActiveRecord::Schema[8.1].define(version: 2026_06_18_043406) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agents", force: :cascade do |t|
    t.text "bio"
    t.string "brokerage"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "license_number"
    t.string "name"
    t.string "phone"
    t.string "profile_color"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_agents_on_email", unique: true
    t.index ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "agent_id", null: false
    t.string "budget"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "portal_token", null: false
    t.string "pre_approval_amount"
    t.string "pre_approved", default: "No"
    t.string "stage", default: "Searching"
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_clients_on_agent_id"
    t.index ["portal_token"], name: "index_clients_on_portal_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "sender_id", null: false
    t.string "sender_type", null: false
    t.bigint "tour_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_messages_on_tour_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "agent_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.string "notif_type"
    t.boolean "read", default: false, null: false
    t.bigint "tour_id"
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_notifications_on_agent_id"
    t.index ["tour_id"], name: "index_notifications_on_tour_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "address", null: false
    t.integer "baths"
    t.integer "beds"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "mls_id"
    t.text "notes"
    t.integer "position"
    t.string "price"
    t.bigint "tour_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_properties_on_tour_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.bigint "property_id", null: false
    t.datetime "updated_at", null: false
    t.integer "value", null: false
    t.index ["client_id"], name: "index_ratings_on_client_id"
    t.index ["property_id", "client_id"], name: "index_ratings_on_property_id_and_client_id", unique: true
    t.index ["property_id"], name: "index_ratings_on_property_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "address", null: false
    t.integer "baths"
    t.integer "beds"
    t.string "city"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.string "price"
    t.string "status", default: "pending"
    t.bigint "tour_id", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_suggestions_on_client_id"
    t.index ["tour_id"], name: "index_suggestions_on_tour_id"
  end

  create_table "tours", force: :cascade do |t|
    t.bigint "agent_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "post_notes"
    t.string "status", default: "draft"
    t.date "tour_date"
    t.string "tour_time"
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_tours_on_agent_id"
    t.index ["client_id"], name: "index_tours_on_client_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clients", "agents"
  add_foreign_key "messages", "tours"
  add_foreign_key "notifications", "agents"
  add_foreign_key "notifications", "tours"
  add_foreign_key "properties", "tours"
  add_foreign_key "ratings", "clients"
  add_foreign_key "ratings", "properties"
  add_foreign_key "suggestions", "clients"
  add_foreign_key "suggestions", "tours"
  add_foreign_key "tours", "agents"
  add_foreign_key "tours", "clients"
end
