class AddStatusCodeToFetches < ActiveRecord::Migration[7.0]
  def change
    add_column :fetches, :status_code, :string
  end
end
