class QueuesController < ApplicationController
  def show
    entries = current_user
      .queue
      .entries
      .includes(feed: :rss_image)
      .order("playlist_items DESC")

    @episodes = EpisodeCollection.new(entries:, user: current_user).episodes
  end
end
