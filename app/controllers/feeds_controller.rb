class FeedsController < ApplicationController
  def index
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
