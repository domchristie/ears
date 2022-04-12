class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :feed, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.string :url
      t.string :author
      t.datetime :published_at
      t.datetime :last_modified_at
      t.string :guid
      t.string :image
      t.string :itunes_author
      t.boolean :itunes_block
      t.integer :itunes_duration
      t.boolean :itunes_explicit
      t.string :itunes_keywords
      t.text :itunes_subtitle
      t.string :itunes_image
      t.boolean :itunes_closed_captioned
      t.integer :itunes_order
      t.integer :itunes_season
      t.integer :itunes_episode
      t.string :itunes_title
      t.string :itunes_episode_type
      t.text :itunes_summary
      t.integer :enclosure_length
      t.string :enclosure_type
      t.string :enclosure_url

      t.timestamps
    end
  end
end
