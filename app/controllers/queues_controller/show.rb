class QueuesController::Show < ControllerAction
  include EpisodeListable

  def episodes
    @episodes ||= EpisodeCollection.new(
      entries: current_user.queued_entries.includes(feed: :rss_image),
      user: current_user,
      limit: @limit,
      order: "playlist_items.created_at DESC"
    ).episodes
  end

  def more_feeds
    @more_feeds ||= current_user
      .queued_feeds
      .where.not(id: episodes.map(&:feed_id))
      .group(:id)
      .includes(:rss_image)
      .joins(:playlist_items)
      .order("MAX(playlist_items.created_at) DESC")
      .limit(DEFAULT_MORE_FEEDS_LIMIT)
  end
end
