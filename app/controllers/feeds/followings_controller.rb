class Feeds::FollowingsController < ApplicationController
  def create
    feed = Feed.find_by_hashid!(params[:feed_id])
    @following = current_user.followings.create!(
      feed: feed,
      sourceable: current_user
    )
    redirect_to feed_path(@following.feed)
  end
end
