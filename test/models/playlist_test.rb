require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "#append! creates a PlaylistItem" do
    playlist = playlists(:queue)
    entry = entries(:two)
    refute playlist.entries.include?(entry)

    assert_difference(-> { PlaylistItem.count }) { playlist.append!(entry) }
    assert playlist.entries.include?(entry)
  end
end
