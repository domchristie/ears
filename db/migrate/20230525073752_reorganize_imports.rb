class ReorganizeImports < ActiveRecord::Migration[7.0]
  def up
    drop_table :imports
    rename_table :synchronizations, :imports
    Import.update_all(type: "Feed::Import")
    rename_column :fetches, :synchronization_id, :import_id
  end

  def down
    rename_column :fetches, :import_id, :synchronization_id
    Import.update_all(type: "Feed::Synchronization")
    rename_table :imports, :synchronizations

    create_table :imports do |t|
      t.string :type, null: false
      t.string :resource_type
      t.bigint :resource_id
      t.datetime :started_at
      t.datetime :finished_at
      t.string :error
      t.bigint :synchronization_id

      t.timestamps
    end
  end
end
