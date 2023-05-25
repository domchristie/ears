class CreateImports < ActiveRecord::Migration[7.0]
  def change
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
