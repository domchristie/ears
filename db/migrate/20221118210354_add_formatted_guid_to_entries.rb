class AddFormattedGuidToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :formatted_guid, :virtual, type: :string, as: "REGEXP_REPLACE(guid,'http(s)?://', '') ", stored: true
  end
end
