class FeedsController < ApplicationController
  def index
    @recently_played = Feed
      .all
      .joins(:plays)
      .group("feeds.id")
      .order("max(plays.updated_at) DESC NULLS LAST")
      .limit(10)

    @recently_updated = Feed
      .all
      .joins(:entries)
      .group("feeds.id")
      .order("max(entries.published_at) DESC")
      .limit(10)

    @feeds = Feed.all.includes(:rss_image).order(title: :asc)
  end

  def show
    @feed = Feed.find(params[:id])

    if !@feed.last_checked_at
      SyncFeedJob.perform_now(@feed, source: :feeds_show)
      @feed.reload
    end

    @entries = @feed.entries.order(published_at: :desc)
  end
end
