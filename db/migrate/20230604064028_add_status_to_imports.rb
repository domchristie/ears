class AddStatusToImports < ActiveRecord::Migration[7.0]
  def up
    add_column :imports, :status, :string
    Import.joins(:import_fetches).where("import_fetches.status_code ILIKE ?", "2%").update_all(status: :success)
    Import.joins(:import_fetches).where("import_fetches.status_code ILIKE ?", "3%").update_all(status: :not_modified)
    Import.joins(:import_fetches).where("import_fetches.status_code ILIKE ?", "4%").update_all(status: :error)
    Import.joins(:import_fetches).where("import_fetches.status_code ILIKE ?", "5%").update_all(status: :error)
  end

  def down
    remove_column :imports, :status
  end
end
