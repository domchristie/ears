class SetupCurrentFollowings < ActiveRecord::Migration[7.0]
  def up
    user_id = User.first.id
    Following.insert_all(
      Feed.pluck(:id).map { |id| {feed_id: id, user_id: user_id} },
      record_timestamps: true
    )
  end

  def down
    Following.destroy_all
  end
end
