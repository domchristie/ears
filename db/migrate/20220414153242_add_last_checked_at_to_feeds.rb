class AddLastCheckedAtToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :last_checked_at, :datetime
  end
end
