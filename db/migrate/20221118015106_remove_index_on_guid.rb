class RemoveIndexOnGuid < ActiveRecord::Migration[7.0]
  def up
    remove_index :entries, :guid
  end

  def down
    add_index :entries, :guid, unique: true
  end
end
