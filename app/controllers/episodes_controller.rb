class EpisodesController < ApplicationController
  before_action :authenticate

  def index
    @episodes = EpisodeCollection.new(
      entries: current_user
        .followed_entries
        .includes(feed: :rss_image)
        .order(published_at: :desc),
      user: current_user
    ).episodes(limit: 25)
  end
end
