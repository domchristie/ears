class AddNotFoundToImportStatus < ActiveRecord::Migration[7.0]
  def up
    Import.where(status: 2).update_all(status: 3)
  end

  def down
    Import.where(status: 3).update_all(status: 2)
  end
end
