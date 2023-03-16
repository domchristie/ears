class User::Dashboard
  def initialize(user)
    @user = user
  end

  def recently_played
    @recently_played ||= EpisodeCollection.new(
      entries: @user.played_entries.includes(:plays, feed: :rss_image),
      user: @user
    ).episodes(limit: 3, order: "plays.updated_at DESC")
  end

  def recently_updated
    @recently_updated ||= EpisodeCollection.new(
      entries: @user.followed_entries.includes(feed: :rss_image),
      user: @user
    ).episodes(limit: 3)
  end

  def queue_episodes
    EpisodeCollection.new(
      entries: @user.queued_entries.includes(:playlist_items, feed: :rss_image),
      user: @user
    ).episodes(limit: 3, order: "playlist_items.created_at DESC")
  end
end
