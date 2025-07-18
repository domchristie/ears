class CreateImportExtractions < ActiveRecord::Migration[8.0]
  def change
    create_table :import_extractions do |t|
      t.references :import, null: false, foreign_key: true
      t.references :extraction, null: false, foreign_key: true

      t.timestamps
    end
  end
end
