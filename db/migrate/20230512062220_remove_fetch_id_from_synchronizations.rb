class RemoveFetchIdFromSynchronizations < ActiveRecord::Migration[7.0]
  def change
    remove_column :synchronizations, :fetch_id
  end
end
