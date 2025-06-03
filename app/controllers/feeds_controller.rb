class FeedsController < ApplicationController
  etag { Current.user&.id }

  def index
    @feeds = Feed
      .followed_by(current_user)
      .includes(:rss_image)
      .group(:id)
      .order(title: :asc)
  end

  def show
    @feed = Feed.find_by_hashid!(params[:id])
    @feed.sync(:feeds_show) if @feed.empty?

    @episodes ||= Episode.belonging_to(
      Current.user, @feed, search_term: params[:query]
    )

    fresh_when(@feed, last_modified: @feed.last_modified)
  end
end
