class ReplaceStatusStringColumnWithEnumOnImports < ActiveRecord::Migration[7.0]
  def up
    rename_column :imports, :status, :old_status
    add_column :imports, :status, :integer

    Import.find_each do |import|
      import.update_column(:status, Import.statuses[import.old_status])
    end

    remove_column :imports, :old_status
  end

  def down
    rename_column :imports, :status, :old_status
    add_column :imports, :status, :string

    Import.find_each do |import|
      import.update_column(:status, import.status)
    end

    remove_column :imports, :old_status
  end
end
