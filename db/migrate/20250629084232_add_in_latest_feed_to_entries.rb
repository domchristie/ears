class AddInLatestFeedToEntries < ActiveRecord::Migration[8.0]
  def up
    add_column :entries, :in_latest_feed, :boolean
    Entry.update_all(in_latest_feed: true)
  end

  def down
    remove_column :entries, :in_latest_feed
  end
end
