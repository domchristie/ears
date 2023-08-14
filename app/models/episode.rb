class Episode
  include ActiveModel::API

  attr_accessor :entry, :user
  attr_writer :play, :queue_item, :following

  delegate_missing_to :entry

  def play
    @play ||= Play.new({
      entry:, user:,
      elapsed: 0,
      remaining: entry.duration
    }.compact)
  end

  def queue_item
    @queue_item ||= PlaylistItem.new(entry: entry)
  end

  def following
    @following ||= Following.new(feed:, user:)
  end
end
