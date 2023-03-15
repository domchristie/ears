require "test_helper"

class PlaylistingTest < ActionDispatch::IntegrationTest
  test "playlisting creates a following" do
    feed = feeds(:two)
    user = users(:one)
    entry = feed.entries.first
    refute Following.where(user:, feed:).exists?

    sign_in_as user
    post queue_items_path, params: {playlist_item: {entry_id: entry.id}}

    assert Following.where(
      user:,
      feed:,
      sourceable_type: "PlaylistItem",
      sourceable_id: PlaylistItem.find_by(playlist: user.queue, entry:).id
    ).exists?
  end
end
