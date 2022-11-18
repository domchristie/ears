class AddUniqueIndexOnGuidAndFeedIdOnEntries < ActiveRecord::Migration[7.0]
  def change
    add_index(:entries, [:feed_id, :guid], unique: true)
  end
end
