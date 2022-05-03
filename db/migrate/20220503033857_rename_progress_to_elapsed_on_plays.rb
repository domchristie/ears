class RenameProgressToElapsedOnPlays < ActiveRecord::Migration[7.0]
  def change
    rename_column :plays, :progress, :elapsed
  end
end
