class AddTypeToPlayLaterPlaylists < ActiveRecord::Migration[7.0]
  def up
    Playlist.where(name: "Queue").find_each do |playlist|
      playlist.update_columns name: "Play Later", type: "PlayLaterPlaylist"
    end
  end
end
