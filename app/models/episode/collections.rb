module Episode::Collections
  extend ActiveSupport::Concern

  class_methods do
    def played_by(user, order: "plays.updated_at DESC", limit: 25)
      Episode::Collection.new(
        entries: user.played_entries.includes(feed: [:rss_image]),
        user:,
        order:,
        limit:
      )
    end

    def all(user, order: {published_at: :desc}, limit: 25)
      Episode::Collection.new(
        entries: user.followed_entries.in_latest_feed.includes(feed: [:rss_image]),
        user:,
        order:,
        limit:
      )
    end

    def play_later_for(user, order: "playlist_items.created_at DESC", limit: 25)
      Episode::Collection.new(
        entries: user.play_later_entries.includes(feed: [:rss_image]),
        user:,
        order:,
        limit:
      )
    end

    def belonging_to(user, feed, search_term: nil, order: {published_at: :desc}, limit: 25)
      Episode::Collection.new(
        entries: feed.entries.in_latest_feed.search(search_term),
        user:,
        order:,
        limit:
      )
    end
  end
end
