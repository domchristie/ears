class FeedsController < ApplicationController
  def index
    @feeds = Feed.all.includes(:rss_image).order(title: :asc)
  end

  def show
    @feed = Feed.find(params[:id])

    if !@feed.last_checked_at
      @feed.sync!
      @feed.reload
    end
  end
end
