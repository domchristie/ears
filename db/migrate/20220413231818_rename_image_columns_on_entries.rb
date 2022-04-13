class RenameImageColumnsOnEntries < ActiveRecord::Migration[7.0]
  def change
    rename_column :entries, :image, :image_url
    rename_column :entries, :itunes_image, :itunes_image_url
  end
end
