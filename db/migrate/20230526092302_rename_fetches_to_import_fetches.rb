class RenameFetchesToImportFetches < ActiveRecord::Migration[7.0]
  def change
    rename_table :fetches, :import_fetches
  end
end
