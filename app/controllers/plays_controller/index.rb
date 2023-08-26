class PlaysController::Index < ControllerAction
  include EpisodeListable

  def episodes
    @episodes ||= EpisodeCollection.new(
      entries: current_user.played_entries.includes(feed: :rss_image),
      user: current_user
    ).episodes(limit: @limit, order: "plays.updated_at DESC")
  end

  def more_feeds
    @more_feeds ||= current_user
      .played_feeds
      .where.not(id: episodes.map(&:feed_id))
      .group(:id)
      .includes(:rss_image)
      .joins(:plays)
      .order("MAX(plays.updated_at) DESC")
      .limit(DEFAULT_MORE_FEEDS_LIMIT)
  end
end
