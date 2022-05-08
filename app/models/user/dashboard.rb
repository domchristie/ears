class User::Dashboard
  def initialize(user)
    @user = user
  end

  def recently_played
    @recently_played ||= Feed
      .joins(:most_recent_current_user_play)
      .includes(:rss_image, most_recent_current_user_play: :entry)
      .group(:id)
      .order("max(plays.updated_at) DESC NULLS LAST")
      .limit(10)
  end

  def recently_updated
    @recently_updated ||= Feed
      .joins(:entries)
      .includes(:rss_image, most_recent_entry: :most_recent_current_user_play)
      .group(:id)
      .order("max(entries.published_at) DESC")
      .limit(10)
  end

  def feeds
    @feeds ||= Feed.includes(:rss_image).order(title: :asc)
  end
end
