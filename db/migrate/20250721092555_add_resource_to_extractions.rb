class AddResourceToExtractions < ActiveRecord::Migration[8.0]
  def up
    add_reference :extractions, :resource, polymorphic: true

    Extraction.where.missing(:imports).in_batches(of: 10).destroy_all

    Extraction.includes(recent_import: :resource).find_each(batch_size: 10) do |extraction|
      next unless extraction.recent_import

      extraction.update_columns(
        resource_type: extraction.recent_import.resource_type,
        resource_id: extraction.recent_import.resource_id
      )
    end

    change_column_null :extractions, :resource_type, false
    change_column_null :extractions, :resource_id, false
  end

  def down
    remove_reference :extractions, :resource, polymorphic: true
  end
end
