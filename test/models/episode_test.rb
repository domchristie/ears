require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  setup do
    @entry = entries(:one)
    @user = users(:one)
  end

  test "#play builds a new record" do
    episode = Episode.new(entry: @entry, user: @user, play: nil)
    assert episode.play.new_record?
    assert_equal @entry, episode.play.entry
    assert_equal @user, episode.play.user
    assert_equal 0, episode.play.elapsed
    assert_equal @entry.duration, episode.play.remaining
  end

  test "#play returns the record" do
    play = plays(:one)
    episode = Episode.new(entry: @entry, user: @user, play:)
    assert_equal play, episode.play
  end

  test "delegating missing methods to entry" do
    episode = Episode.new(entry: @entry, user: @user, play: nil)
    assert_equal @entry.guid, episode.guid
  end
end
