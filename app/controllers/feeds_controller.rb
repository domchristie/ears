class FeedsController < ApplicationController
  etag { current_user&.id }

  def index
    @feeds = Feed
      .followed_by(current_user)
      .includes(:rss_image)
      .group(:id)
      .order(title: :asc)
  end

  def show
    @show = Show.call(self)
    fresh_when(@show.feed, last_modified: @show.last_modified)
  end
end
