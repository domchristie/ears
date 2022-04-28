class FeedsController < ApplicationController
  def index
    @recently_played = Feed
      .joins(:most_recent_play)
      .includes(:rss_image, most_recent_play: :entry)
      .group(:id)
      .order("max(plays.updated_at) DESC NULLS LAST")
      .limit(10)

    @recently_updated = Feed
      .joins(:entries)
      .includes(:rss_image, :most_recent_entry)
      .group(:id)
      .order("max(entries.published_at) DESC")
      .limit(10)

    @feeds = Feed.includes(:rss_image).order(title: :asc)
  end

  def show
    @feed = Feed.find(params[:id])

    if !@feed.last_checked_at
      SyncFeedJob.perform_now(@feed, source: :feeds_show)
      @feed.reload
    end

    @entries = @feed.entries.order(published_at: :desc).limit(52) # TODO pagination
  end
end
