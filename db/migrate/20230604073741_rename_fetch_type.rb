class RenameFetchType < ActiveRecord::Migration[7.0]
  def up
    Import::Fetch.where(type: "Feed::Fetch").update_all(type: "Feed::Import::Fetch")
  end

  def down
    Import::Fetch.where(type: "Feed::Import::Fetch").update_all(type: "Feed::Fetch")
  end
end
