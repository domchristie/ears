class CreateTableOfContents < ActiveRecord::Migration[7.0]
  def change
    create_table :table_of_contents do |t|
      t.references :entry, null: false, foreign_key: true
      t.string :version
      t.string :author
      t.string :title
      t.string :podcast_name
      t.string :description
      t.string :file_name
      t.boolean :waypoints

      t.timestamps
    end
  end
end
