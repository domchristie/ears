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

ActiveRecord::Schema[7.0].define(version: 2023_06_23_141749) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
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

  create_table "chapters", force: :cascade do |t|
    t.bigint "table_of_contents_id", null: false
    t.float "start_time", null: false
    t.string "title"
    t.string "image_url"
    t.string "url"
    t.boolean "toc"
    t.float "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_of_contents_id"], name: "index_chapters_on_table_of_contents_id"
  end

  create_table "email_verification_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_email_verification_tokens_on_user_id"
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
    t.string "podcast_chapters_url"
    t.string "podcast_chapters_type"
    t.virtual "formatted_guid", type: :string, as: "regexp_replace((guid)::text, 'http(s)?://'::text, ''::text)", stored: true
    t.index ["feed_id", "formatted_guid"], name: "index_entries_on_feed_id_and_formatted_guid", unique: true
    t.index ["feed_id"], name: "index_entries_on_feed_id"
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
    t.string "web_sub_hub_url"
    t.datetime "last_modified_at"
    t.string "etag"
    t.bigint "itunes_id"
    t.index ["itunes_id"], name: "index_feeds_on_itunes_id", unique: true
    t.index ["url"], name: "index_feeds_on_url", unique: true
  end

  create_table "followings", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sourceable_type"
    t.bigint "sourceable_id"
    t.index ["feed_id", "user_id"], name: "index_followings_on_feed_id_and_user_id", unique: true
    t.index ["feed_id"], name: "index_followings_on_feed_id"
    t.index ["sourceable_type", "sourceable_id"], name: "index_followings_on_sourceable"
    t.index ["user_id"], name: "index_followings_on_user_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "import_fetches", force: :cascade do |t|
    t.string "type", null: false
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.boolean "conditional", default: true
    t.string "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_code"
    t.bigint "import_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string "type", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "resource_type"
    t.bigint "resource_id"
    t.boolean "conditional", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source", null: false
    t.integer "status"
  end

  create_table "opml_imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_password_reset_tokens_on_user_id"
  end

  create_table "playlist_items", force: :cascade do |t|
    t.bigint "playlist_id", null: false
    t.bigint "entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_playlist_items_on_entry_id"
    t.index ["playlist_id"], name: "index_playlist_items_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "plays", force: :cascade do |t|
    t.float "elapsed"
    t.bigint "entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "remaining", default: 0.0
    t.bigint "feed_id", null: false
    t.bigint "user_id", null: false
    t.index ["entry_id"], name: "index_plays_on_entry_id"
    t.index ["feed_id"], name: "index_plays_on_feed_id"
    t.index ["user_id", "entry_id"], name: "index_plays_on_user_id_and_entry_id", unique: true
    t.index ["user_id"], name: "index_plays_on_user_id"
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

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "table_of_contents", force: :cascade do |t|
    t.bigint "entry_id", null: false
    t.string "version"
    t.string "author"
    t.string "title"
    t.string "podcast_name"
    t.string "description"
    t.string "file_name"
    t.boolean "waypoints"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_modified_at"
    t.string "etag"
    t.index ["entry_id"], name: "index_table_of_contents_on_entry_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.string "unconfirmed_email"
    t.boolean "verified", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
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
  add_foreign_key "chapters", "table_of_contents", column: "table_of_contents_id"
  add_foreign_key "email_verification_tokens", "users"
  add_foreign_key "entries", "feeds"
  add_foreign_key "followings", "feeds"
  add_foreign_key "followings", "users"
  add_foreign_key "password_reset_tokens", "users"
  add_foreign_key "playlist_items", "entries"
  add_foreign_key "playlist_items", "playlists"
  add_foreign_key "playlists", "users"
  add_foreign_key "plays", "entries"
  add_foreign_key "plays", "feeds"
  add_foreign_key "plays", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "table_of_contents", "entries"
  add_foreign_key "web_subs", "feeds", column: "feed_url", primary_key: "url"
end
