class Feeds::FollowingsController < ApplicationController
  def create
    @following = Current.user.followings.create(following_params)
    redirect_to feed_path(@following.feed)
  end

  private

  def following_params
    params.permit(:feed_id)
  end
end
