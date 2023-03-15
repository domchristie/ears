class User::Dashboard
  def initialize(user)
    @user = user
  end

  def queue_episodes
    EpisodeCollection.new(
      entries: @user.queue.entries.includes(feed: :rss_image).order("playlist_items DESC"),
      user: @user
    ).episodes(limit: 3)
  end

  def recently_played
    @recently_played ||= @user
      .played_feeds
      .joins(:plays)
      .where(plays: {user: @user})
      .includes(:rss_image)
      .group(:id)
      .order("max(plays.updated_at) DESC NULLS LAST")
      .limit(10)
  end

  def recently_updated
    @recently_updated ||= Feed
      .followed_by(@user)
      .joins(:entries)
      .includes(:rss_image, :most_recent_entry)
      .group(:id)
      .order("max(entries.published_at) DESC")
      .limit(10)
  end

  def feeds
    @feeds ||= Feed
      .followed_by(@user)
      .includes(:rss_image)
      .group(:id)
      .order(title: :asc)
  end
end
