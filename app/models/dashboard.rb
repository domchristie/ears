class Dashboard
  def initialize(user)
    @user = user
  end

  def played
    @played ||= Episode.played_by(@user, limit: 3)
  end

  def more_played_feeds
    @more_played_feeds ||= played.more_feeds(
      :played_feeds, joins: :plays, order: "MAX(plays.updated_at) DESC"
    )
  end

  def recently_updated
    @recently_updated ||= Episode.all(@user, limit: 3)
  end

  def more_recently_updated_feeds
    @more_recently_updated_feeds ||= recently_updated.more_feeds(
      :followed_feeds,
      joins: :most_recent_entry,
      order: "MAX(entries.published_at) DESC"
    )
  end

  def play_later
    @play_later ||= Episode.play_later_for(@user, limit: 3)
  end

  def more_play_later_feeds
    @more_play_later_feeds ||= play_later.more_feeds(
      :play_later_feeds,
      joins: :playlist_items,
      order: "MAX(playlist_items.created_at) DESC"
    )
  end
end
