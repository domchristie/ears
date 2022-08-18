class FollowingsController < ApplicationController
  def create
    @following = Following.create!(following_params)

    respond_to do |format|
      format.html { redirect_back_or_to root_path }
      format.turbo_stream { render "form" }
    end
  end

  def destroy
    outgoing = Following.find(params[:id])
    @following = outgoing.dup
    outgoing.destroy!

    respond_to do |format|
      format.html { redirect_back_or_to root_path }
      format.turbo_stream { render "form" }
    end
  end

  private

  def following_params
    params
      .require(:following)
      .permit(
        :user_id,
        :feed_id,
        feed_attributes: [:url, :title, :itunes_image]
      )
  end
end
