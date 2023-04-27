class CreateSynchronizations < ActiveRecord::Migration[7.0]
  def change
    create_table :synchronizations do |t|
      t.string :type, null: false
      t.datetime :started_at
      t.datetime :finished_at
      t.string :resource_type
      t.bigint :resource_id
      t.references :fetch, null: false, foreign_key: true
      t.boolean :conditional, default: true

      t.timestamps
    end
  end
end
