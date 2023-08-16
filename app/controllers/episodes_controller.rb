class EpisodesController < ApplicationController
  before_action :authenticate

  def index
    @episodes = EpisodeCollection.new(
      entries: Entry
        .includes(:following, feed: :rss_image)
        .where(followings: {user: current_user}),
      user: current_user
    ).episodes(limit: 25)
  end
end
