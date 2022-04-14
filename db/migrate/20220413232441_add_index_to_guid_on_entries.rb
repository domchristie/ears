class AddIndexToGuidOnEntries < ActiveRecord::Migration[7.0]
  def change
    add_index :entries, :guid, unique: true
  end
end
