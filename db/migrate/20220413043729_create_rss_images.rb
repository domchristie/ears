class CreateRssImages < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_images do |t|
      t.references :rss_imageable, null: false, polymorphic: true
      t.string :url, null: false
      t.text :description
      t.string :title
      t.integer :width
      t.integer :height
      t.string :website_url

      t.timestamps
    end
  end
end
