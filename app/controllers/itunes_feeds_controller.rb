class ItunesFeedsController < ApplicationController
  def show
    itunes_feed = ItunesFeed.new(params[:apple_id])
    feed = Feed.find_or_create_by(url: itunes_feed.feed_url)

    params[:id] = feed.hashid
    @show = FeedsController::Show.call(self)
    render "feeds/show"
  end
end
