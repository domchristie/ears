require "test_helper"

class PlaylistingTest < ActionDispatch::IntegrationTest
  test "playlisting creates a following" do
    feed = feeds.two
    entry = feed.entries.first
    user = sign_in_as users.one
    refute user.followings.exists?(feed:)

    post play_later_items_path, params: {playlist_item: {entry_id: entry.id}}

    assert user.followings.where(
      feed:,
      sourceable: user.play_later_playlist.items.find_by(entry:)
    ).exists?
  end
end
