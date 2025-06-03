class EpisodesController < ApplicationController
  def index
    @episodes = Episode.all(Current.user)
  end
end
