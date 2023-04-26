class CreateFetches < ActiveRecord::Migration[7.0]
  def change
    create_table :fetches do |t|
      t.string :type, null: false
      t.string :resource_type
      t.bigint :resource_id
      t.datetime :started_at
      t.datetime :finished_at
      t.boolean :conditional, default: true
      t.string :error

      t.timestamps
    end
  end
end
