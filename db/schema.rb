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

ActiveRecord::Schema[7.1].define(version: 2026_10_09_205459) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "channels", force: :cascade do |t|
    t.bigint "opportunity_id", null: false
    t.integer "channel_type", default: 0, null: false
    t.integer "outcome_status", default: 0, null: false
    t.string "link"
    t.string "contact_name"
    t.string "contact_email"
    t.string "cv_version"
    t.datetime "sent_at"
    t.datetime "follow_up_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follow_up_at"], name: "index_channels_on_follow_up_at"
    t.index ["opportunity_id"], name: "index_channels_on_opportunity_id"
    t.index ["outcome_status"], name: "index_channels_on_outcome_status"
  end

  create_table "opportunities", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "title", null: false
    t.text "requirements"
    t.text "product_description"
    t.string "source_url"
    t.date "found_at"
    t.date "checked_at"
    t.date "deadline"
    t.integer "posting_status", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.integer "track", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_opportunities_on_organization_id"
    t.index ["posting_status"], name: "index_opportunities_on_posting_status"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0, null: false
    t.string "location"
    t.string "website"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submission_events", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.integer "event_type", default: 0, null: false
    t.datetime "occurred_at", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_submission_events_on_channel_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "channels", "opportunities"
  add_foreign_key "opportunities", "organizations"
  add_foreign_key "submission_events", "channels"
end
