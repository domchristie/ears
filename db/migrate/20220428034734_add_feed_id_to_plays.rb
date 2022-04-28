class AddFeedIdToPlays < ActiveRecord::Migration[7.0]
  def up
    add_reference :plays, :feed, foreign_key: true

    Play.includes(:entry).find_each do |play|
      play.update_column(:feed_id, play.entry.feed_id)
    end

    change_column_null :plays, :feed_id, false
  end

  def down
    remove_reference :plays, :feed
  end
end
