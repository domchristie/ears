class PlayLaterPlaylist < Playlist
  validates :user_id, uniqueness: true
end
