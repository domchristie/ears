require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "#prepend_entry creates a PlaylistItem" do
    playlist = playlists(:play_later)
    entry = entries(:two)
    refute playlist.entries.include?(entry)

    assert_difference(-> { PlaylistItem.count }) do
      playlist.prepend_entry(entry)
    end
    assert playlist.entries.include?(entry)
  end
end
