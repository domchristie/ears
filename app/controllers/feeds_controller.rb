class FeedsController < ApplicationController
  def show
    @feed_show = Feed::Show.new(params)
    @feed_show.start
  end
end
