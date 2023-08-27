class EpisodesController::Index < ControllerAction
  include EpisodeListable

  def episodes
    @episodes ||= EpisodeCollection.new(
      entries: current_user.followed_entries.includes(feed: :rss_image),
      user: current_user,
      limit: @limit
    ).episodes
  end

  def more_feeds
    @more_feeds ||= current_user
      .followed_feeds
      .where.not(id: episodes.map(&:feed_id))
      .group(:id)
      .includes(:rss_image)
      .joins(:most_recent_entry)
      .order("MAX(entries.published_at) DESC")
      .limit(DEFAULT_MORE_FEEDS_LIMIT)
  end
end
