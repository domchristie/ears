class AddLastModifiedAtAndEtagToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :last_modified_at, :datetime
    add_column :feeds, :etag, :string
  end
end
