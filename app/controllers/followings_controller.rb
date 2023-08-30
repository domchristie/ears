class FollowingsController < ApplicationController
  def create
    feed = Feed.find_by_hashid!(params[:feed_id])
    @following = current_user.followings.create_or_find_by!(
      feed: feed,
      sourceable: current_user
    )
    redirect_back_or_to feed_path(feed)
  end

  def destroy
    feed = Feed.find_by_hashid!(params[:feed_id])
    following = current_user.followings.find_by(feed:)

    if following
      following.destroy!
      @following = Following.new(feed:)
    end

    redirect_back_or_to feed_path(feed)
  end
end
