class AddSynchronizationIdToFetches < ActiveRecord::Migration[7.0]
  def up
    add_column :fetches, :synchronization_id, :bigint
    Fetch.update_all("synchronization_id = (SELECT id FROM synchronizations WHERE fetch_id = fetches.id LIMIT 1)")
  end

  def down
    remove_column :fetches, :synchronization_id, :bigint
  end
end
