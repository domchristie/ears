class EpisodeCollection
  attr_reader :user, :query

  def initialize(entries:, user:, query: nil)
    @entries = entries
    @user = user
    @query = query.presence
  end

  def episodes(order: {published_at: :desc}, limit: nil)
    entries
      .then { |entries| query ? entries.entry_search(query) : entries }
      .order(order)
      .limit(limit)
      .map { |entry| build_episode(entry) }
  end

  private

  def build_episode(entry)
    Episode.new(entry:, user:, play: entry.recent_play, queue_item: entry.queue_item, following: entry.following)
  end

  def entries
    @entries
      .includes(:recent_play, :queue_item, :following)
      .where("plays.user_id = ? OR plays.user_id IS NULL", user.id)
      .where(
        "playlist_items.playlist_id = ? OR playlist_items.playlist_id IS NULL",
        user.queue&.id
      )
      .where("followings.user_id = ? OR followings.user_id IS NULL", user.id)
      .references(:plays, :playlist_items, :followings)
  end
end
