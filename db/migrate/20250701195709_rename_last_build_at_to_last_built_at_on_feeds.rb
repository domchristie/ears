class RenameLastBuildAtToLastBuiltAtOnFeeds < ActiveRecord::Migration[8.0]
  def change
    rename_column :feeds, :last_build_at, :last_built_at
  end
end
