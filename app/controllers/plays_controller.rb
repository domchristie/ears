class PlaysController < ApplicationController
  def index
    @episodes = Episode.played_by(Current.user)
  end
end
