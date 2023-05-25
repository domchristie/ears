class RemoveSourceAndLastCheckedAtFromFeeds < ActiveRecord::Migration[7.0]
  def change
    remove_column :feeds, :import_source, :string
    remove_column :feeds, :last_checked_at, :datetime
  end
end
