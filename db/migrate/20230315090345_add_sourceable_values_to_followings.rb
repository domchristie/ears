class AddSourceableValuesToFollowings < ActiveRecord::Migration[7.0]
  def up
    User.find_each do |user|
      feeds = Feed.where(id: user.played_feeds)
        .or(Feed.where(id: user.playlisted_feeds))

      feeds.find_each do |feed|
        following = Following.find_or_initialize_by(user:, feed:)

        if following.persisted?
          following.update_columns(sourceable_type: "User", sourceable_id: user.id)
          next
        end

        play = Play.find_by(user:, feed:)
        playlist_item = PlaylistItem
          .joins(:feed, :user)
          .where(users: {id: user.id}, feeds: {id: feed.id})
          .first

        raise "No sourceable for Feed ##{feed.id}" if !play && !playlist_item

        sourceable = if play && !playlist_item
          play
        elsif !play && playlist_item
          playlist_item
        elsif play.created_at < playlist_item.created_at
          play
        elsif playlist_item.created_at < play.created_at
          playlist_item
        end

        following.update!(
          sourceable_type: sourceable.class.to_s,
          sourceable_id: sourceable.id
        )
        following.update_columns(
          created_at: sourceable.created_at,
          updated_at: sourceable.created_at,
        )
      end
    end
  end

  def down
    Following.where.not(sourceable_type: "User").destroy_all
    Following.update_all(sourceable_type: nil, sourceable_id: nil)
  end
end
