class AddImportSourceToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :import_source, :string
  end
end
