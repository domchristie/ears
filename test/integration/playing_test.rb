require "test_helper"

class PlayingTest < ActionDispatch::IntegrationTest
  test "playing creates a following" do
    feed = feeds(:two)
    user = users(:one)
    entry = feed.entries.first
    refute Following.where(user:, feed:).exists?

    sign_in_as user
    post entry_plays_path(entry), params: {play: {elapsed: 0, remaining: 1}}

    assert Following.where(
      user:,
      feed:,
      sourceable_type: "Play",
      sourceable_id: Play.find_by(user:, entry:).id
    ).exists?
  end
end
