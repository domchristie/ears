class AddCacheColumnsToTableOfContents < ActiveRecord::Migration[7.0]
  def change
    add_column :table_of_contents, :last_modified_at, :datetime
    add_column :table_of_contents, :etag, :string
  end
end
