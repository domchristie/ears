require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  test "#prepend_entry creates a PlaylistItem" do
    playlist = users.one.play_later_playlist
    entry = entries.two
    refute_includes playlist.entries, entries.two

    assert_difference -> { PlaylistItem.count } do
      playlist.prepend_entry(entry)
    end
    assert_includes playlist.entries, entry
  end
end
