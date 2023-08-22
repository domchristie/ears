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
    Episode.new(
      entry:,
      user:,
      play: entry.recent_play,
      queue_item: entry.queue_item,
      following: include_following?.presence && entry.following
    )
  end

  def entries
    @entries
      .includes(:recent_play, :queue_item)
      .where("plays.user_id = ? OR plays.user_id IS NULL", user.id)
      .where(
        "playlist_items.playlist_id = ? OR playlist_items.playlist_id IS NULL",
        user.queue&.id
      )
      .references(:plays, :playlist_items)
  end

  def include_following?
    flatten_includes(@entries.includes_values).include?(:following)
  end

  def flatten_includes(includes)
    includes.map do |inc|
      inc.is_a?(Hash) ? flatten_hash(inc) : inc
    end.flatten.inquiry
  end

  def flatten_hash(hash)
    hash.map do |key, value|
      if value.is_a?(Hash)
        flatten_hash(value)
      else
        [key, value]
      end
    end.flatten
  end
end
