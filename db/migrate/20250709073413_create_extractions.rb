class CreateExtractions < ActiveRecord::Migration[8.0]
  def change
    create_table :extractions do |t|
      t.jsonb :result
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :status
      t.string :error_class

      t.timestamps
    end
  end
end
