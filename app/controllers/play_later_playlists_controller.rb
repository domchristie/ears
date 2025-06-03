class PlayLaterPlaylistsController < ApplicationController
  def show
    @episodes = Episode.play_later_for(Current.user)
  end
end
