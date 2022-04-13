class CreateOpmlImports < ActiveRecord::Migration[7.0]
  def change
    create_table :opml_imports do |t|

      t.timestamps
    end
  end
end
