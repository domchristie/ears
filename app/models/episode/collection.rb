class Episode::Collection
  delegate_missing_to :episodes

  attr_reader :user

  def initialize(entries:, user:, order: {published_at: :desc}, limit: 25)
    @entries = entries.order(order).limit(limit).load
    @user = user
  end

  def more_feeds(method, joins:, order:)
    @more_feeds ||= user
      .send(method)
      .where.not(id: episodes.map(&:feed_id))
      .group(:id)
      .includes(:rss_image)
      .joins(joins)
      .order(order)
      .limit(3)
  end

  def episodes
    @episodes ||= @entries.map { |entry| build_episode(entry) }
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

  def play_later_item_for(entry)
    play_later_items[entry.id] || PlaylistItem.new(entry:, playlist: user.play_later_playlist)
  end

  private

  def build_episode(entry)
    Episode.new(entry:, user:, collection: self)
  end

  def plays
    @plays ||= Play.includes(:entry).where(user:, entry: @entries).map do |play|
      [play.entry_id, play]
    end.to_h
  end

  def followings
    @followings ||= Following.includes(:feed).where(user:, feed: @entries.map(&:feed_id)).map do |following|
      [following.feed_id, following]
    end.to_h
  end

  def play_later_items
    @play_later_items ||= PlaylistItem.includes(:entry).where(playlist: user.play_later_playlist, entry: @entries).map do |play_later_item|
      [play_later_item.entry_id, play_later_item]
    end.to_h
  end
end
