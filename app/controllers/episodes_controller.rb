class EpisodesController < ApplicationController
  before_action :authenticate

  def index
    @episodes = EpisodeCollection.new(
      entries: Entry.includes(feed: :rss_image),
      user: current_user
    ).episodes(limit: 25)
  end
end
