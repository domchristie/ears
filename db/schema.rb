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

ActiveRecord::Schema[7.0].define(version: 2022_04_26_042839) do
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

  create_table "entries", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "title"
    t.text "content"
    t.string "url"
    t.string "author"
    t.datetime "published_at"
    t.datetime "last_modified_at"
    t.string "guid"
    t.string "image_url"
    t.string "itunes_author"
    t.boolean "itunes_block"
    t.integer "itunes_duration"
    t.boolean "itunes_explicit"
    t.string "itunes_keywords"
    t.text "itunes_subtitle"
    t.string "itunes_image_url"
    t.boolean "itunes_closed_captioned"
    t.integer "itunes_order"
    t.integer "itunes_season"
    t.integer "itunes_episode"
    t.string "itunes_title"
    t.string "itunes_episode_type"
    t.text "itunes_summary"
    t.integer "enclosure_length"
    t.string "enclosure_type"
    t.string "enclosure_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["feed_id"], name: "index_entries_on_feed_id"
    t.index ["guid"], name: "index_entries_on_guid", unique: true
  end

  create_table "feeds", force: :cascade do |t|
    t.text "url"
    t.string "copyright"
    t.text "description"
    t.string "image"
    t.string "language"
    t.datetime "last_build_at"
    t.string "website_url"
    t.string "managing_editor"
    t.string "title"
    t.integer "ttl"
    t.string "itunes_author"
    t.boolean "itunes_block"
    t.string "itunes_image"
    t.boolean "itunes_explicit"
    t.boolean "itunes_complete"
    t.string "itunes_keywords"
    t.string "itunes_type"
    t.string "itunes_new_feed_url"
    t.string "itunes_subtitle"
    t.text "itunes_summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_checked_at"
    t.string "web_sub_hub_url"
    t.string "import_source"
    t.datetime "last_modified_at"
    t.string "etag"
    t.index ["url"], name: "index_feeds_on_url", unique: true
  end

  create_table "opml_imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plays", force: :cascade do |t|
    t.float "progress"
    t.bigint "entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_plays_on_entry_id"
  end

  create_table "rss_images", force: :cascade do |t|
    t.string "rss_imageable_type", null: false
    t.bigint "rss_imageable_id", null: false
    t.string "url", null: false
    t.text "description"
    t.string "title"
    t.integer "width"
    t.integer "height"
    t.string "website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rss_imageable_type", "rss_imageable_id"], name: "index_rss_images_on_rss_imageable_type_and_rss_imageable_id", unique: true
  end

  create_table "web_subs", force: :cascade do |t|
    t.string "feed_url", null: false
    t.string "hub_url", null: false
    t.datetime "expires_at"
    t.string "secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_url"], name: "index_web_subs_on_feed_url"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "feeds"
  add_foreign_key "plays", "entries"
  add_foreign_key "web_subs", "feeds", column: "feed_url", primary_key: "url"
end
