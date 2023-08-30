require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  setup do
    @entry = entries(:one)
    @user = users(:one)
    @collection = Minitest::Mock.new
  end

  test "#play lazy loads a play from its collection" do
    play = Play.new
    @collection.expect :play_for, play, [@entry]
    episode = Episode.new(collection: @collection, entry: @entry, user: @user)
    episode.play
    episode.play # check memoization
  end

  test "#queue_item lazy loads a play from its collection" do
    queue_item = PlaylistItem.new
    @collection.expect :queue_item_for, queue_item, [@entry]
    episode = Episode.new(collection: @collection, entry: @entry, user: @user)
    episode.queue_item
    episode.queue_item # check memoization
  end

  test "#following lazy loads a play from its collection" do
    following = Following.new
    @collection.expect :following_for, following, [@entry]
    episode = Episode.new(collection: @collection, entry: @entry, user: @user)
    episode.following
    episode.following # check memoization
  end

  test "delegating missing methods to entry" do
    episode = Episode.new(collection: @collection, entry: @entry, user: @user)
    assert_equal @entry.guid, episode.guid
  end
end
