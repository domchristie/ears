class FeedsController < ApplicationController
  etag { current_user&.id }

  def show
    @feed_show = Feed::Show.new(params)
    @feed_show.start

    fresh_when(
      @feed_show.feed,
      last_modified: [
        @feed_show.feed.updated_at,
        @feed_show.most_recent_entry.published_at,
        @feed_show.most_recent_play.updated_at
      ].compact.max
    )
  end
end
