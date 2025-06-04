class ItunesFeedsController < ApplicationController
  def show
    itunes_feed = ItunesFeed.new(params[:apple_id])
    feed = Feed.find_or_create_by(url: itunes_feed.feed_url)
    redirect_to feed_path(feed), status: :see_other
  end
end
