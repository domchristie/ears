class CreateFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :feeds do |t|
      t.text :url
      t.string :copyright
      t.text :description
      t.string :image
      t.string :language
      t.datetime :last_build_at
      t.string :website_url
      t.string :managing_editor
      t.string :title
      t.integer :ttl
      t.string :itunes_author
      t.boolean :itunes_block
      t.string :itunes_image
      t.boolean :itunes_explicit
      t.boolean :itunes_complete
      t.string :itunes_keywords
      t.string :itunes_type
      t.string :itunes_new_feed_url
      t.string :itunes_subtitle
      t.text :itunes_summary

      t.timestamps
    end
  end
end
