class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.references :table_of_contents, null: false, foreign_key: true
      t.float :start_time, null: false
      t.string :title
      t.string :image_url
      t.string :url
      t.boolean :toc
      t.float :end_time

      t.timestamps
    end
  end
end
