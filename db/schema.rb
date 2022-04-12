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

ActiveRecord::Schema[7.0].define(version: 2022_04_12_154308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "title"
    t.text "content"
    t.string "url"
    t.string "author"
    t.datetime "published_at"
    t.datetime "last_modified_at"
    t.string "guid"
    t.string "image"
    t.string "itunes_author"
    t.boolean "itunes_block"
    t.integer "itunes_duration"
    t.boolean "itunes_explicit"
    t.string "itunes_keywords"
    t.text "itunes_subtitle"
    t.string "itunes_image"
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
  end

  add_foreign_key "entries", "feeds"
end
