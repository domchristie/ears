class AddUniqueIndexToRssImages < ActiveRecord::Migration[7.0]
  def up
    remove_index :rss_images, ["rss_imageable_type", "rss_imageable_id"]
    add_index :rss_images, ["rss_imageable_type", "rss_imageable_id"], unique: true
  end

  def down
    remove_index :rss_images, ["rss_imageable_type", "rss_imageable_id"]
    add_index :rss_images, ["rss_imageable_type", "rss_imageable_id"]
  end
end
