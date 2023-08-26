class EpisodeCollection
  attr_reader :user, :query

  def initialize(entries:, user:, query: nil)
    @entries = entries
    @user = user
    @query = query.presence
  end

  def episodes(order: {published_at: :desc}, limit: 25)
    @episodes ||= @entries
      .then { |entries| query ? entries.entry_search(query) : entries }
      .order(order)
      .limit(limit)
      .map { |entry| build_episode(entry) }
  end

  def play_for(entry)
    plays[entry.id] || Play.new({
      entry:, user:,
      elapsed: 0,
      remaining: entry.duration
    }.compact)
  end

  def following_for(entry)
    followings[entry.feed_id] || Following.new(feed: entry.feed, user:)
  end

  def queue_item_for(entry)
    queue_items[entry.id] || PlaylistItem.new(entry:, playlist: user.queue)
  end

  private

  def build_episode(entry)
    Episode.new(entry:, user:, collection: self)
  end

  def plays
    @plays ||= Play.includes(:entry).where(user:, entry: @episodes.map(&:id)).map do |play|
      [play.entry_id, play]
    end.to_h
  end

  def followings
    @followings ||= Following.includes(:feed).where(user:, feed: @episodes.map(&:feed_id)).map do |following|
      [following.feed_id, following]
    end.to_h
  end

  def queue_items
    @queue_items ||= PlaylistItem.includes(:entry).where(playlist: user.queue).map do |queue_item|
      [queue_item.entry_id, queue_item]
    end.to_h
  end
end
