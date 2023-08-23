class FollowingsController < ApplicationController
  def create
    feed = Feed.find_by_hashid!(params[:feed_id])
    @following = current_user.followings.create_or_find_by!(
      feed: feed,
      sourceable: current_user
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to feed_path(feed), notice: "You are now following #{feed.title}" }
    end
  end

  def destroy
    feed = Feed.find_by_hashid!(params[:feed_id])
    following = current_user.followings.find_by(feed:)

    if following
      following.destroy!
      @following = Following.new(feed:)
    else
      head(:ok)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to feed_path(feed), notice: "You are no longer following #{feed.title}" }
    end
  end
end
