class CreatePlays < ActiveRecord::Migration[7.0]
  def change
    create_table :plays do |t|
      t.float :progress
      t.references :entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
