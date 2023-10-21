class PlayLaterPlaylists::ItemsController < ApplicationController
  def create
    @play_later_item = current_user.play_later_playlist.prepend_entry(
      Entry.find(params[:playlist_item][:entry_id])
    )
    redirect_back_or_to play_later_path
  end

  def destroy
    @play_later_item = current_user.play_later_playlist.remove_entry(
      Entry.find_by_hashid(params[:entry_id])
    )
    redirect_back_or_to play_later_path
  end
end
