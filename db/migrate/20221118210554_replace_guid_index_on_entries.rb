class ReplaceGuidIndexOnEntries < ActiveRecord::Migration[7.0]
  def up
    remove_index :entries, [:feed_id, :guid]
    add_index :entries, [:feed_id, :formatted_guid], unique: true
  end

  def down
    remove_index :entries, [:feed_id, :formatted_guid]
    add_index :entries, [:feed_id, :guid], unique: true
  end
end
