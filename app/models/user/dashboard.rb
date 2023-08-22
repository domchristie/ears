class User::Dashboard
  def initialize(user)
    @user = user
  end

  def recently_played
    @recently_played ||= EpisodeCollection.new(
      entries: @user.played_entries.includes(:recent_play, following: :feed, feed: :rss_image),
      user: @user
    ).episodes(limit: 3, order: "plays.updated_at DESC")
  end

  def additional_recently_played
    @additional_recently_played ||= @user
      .played_feeds
      .where.not(id: recently_played.map(&:feed_id))
      .group(:id)
      .includes(:rss_image)
      .joins(:plays)
      .order("MAX(plays.updated_at) DESC")
      .limit(5)
  end

  def recently_updated
    @recently_updated ||= EpisodeCollection.new(
      entries: @user.followed_entries.includes(feed: :rss_image),
      user: @user
    ).episodes(limit: 3)
  end

  def additional_recently_updated
    @additional_recently_updated ||= @user
      .followed_feeds
      .group(:id)
      .where.not(id: recently_updated.map(&:feed_id))
      .includes(:rss_image)
      .joins(:most_recent_entry)
      .order("MAX(entries.published_at) DESC")
      .limit(5)
  end

  def queue_episodes
    @queue_episodes ||= EpisodeCollection.new(
      entries: @user.queued_entries.includes(:playlist_items, feed: :rss_image),
      user: @user
    ).episodes(limit: 3, order: "playlist_items.created_at DESC")
  end

  def additional_queue_episodes
    @additional_queue_episodes ||= @user
      .queued_feeds
      .where.not(id: queue_episodes.map(&:feed_id))
      .group(:id)
      .includes(:rss_image)
      .joins(:playlist_items)
      .order("MAX(playlist_items.created_at) DESC")
      .limit(5)
  end
end
