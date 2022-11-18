class ConsolidateEntriesWithUnintentionallyDifferentGuids < ActiveRecord::Migration[7.0]
  # Consolidate entries where URL GUID protocols changed from http to https
  # (and  vice-versa). Pick the one with the lowest ID.
  def up
    handled_ids = []
    entry_ids_with_dupes = []

    Entry.find_each do |entry|
      next if handled_ids.include?(entry.id)

      duplicate_ids = Entry
        .where.not(id: entry.id)
        .where("guid ILIKE ?", "%#{entry.guid.gsub(/^http(s)?:\/\//, "")}")
        .pluck(:id)

      entry_ids_with_dupes.push([entry.id, *duplicate_ids]) if duplicate_ids.any?
      handled_ids.push(entry.id, *duplicate_ids)
    end

    entry_ids_with_dupes.each do |ids|
      ids_without_oldest = ids.delete_at(ids.index(ids.min))
      Entry.where(id: ids_without_oldest).destroy_all
    end
  end

  def down
  end
end
