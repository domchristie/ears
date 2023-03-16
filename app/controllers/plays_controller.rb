class PlaysController < ApplicationController
  before_action :authenticate

  def index
    @episodes = EpisodeCollection.new(
      entries: current_user
        .played_entries
        .includes(:plays, feed: :rss_image)
        .order("plays.updated_at DESC"),
      user: current_user
    ).episodes(limit: 25)
  end
end
