require "test_helper"

class Episode::CollectionTest < ActiveSupport::TestCase
  setup { @user = users.one }

  test "#episodes returns a list of Episodes" do
    episodes = self.episodes
    refute_empty episodes
    assert episodes.all?(Episode)
  end

  test "#episodes only contain the user's plays" do
    plays = episodes.map(&:play)
    assert plays.any?(&:persisted?)
    assert plays.all? { it.user == @user }
  end

  test "#episodes limits the number of Episodes" do
    assert_predicate Entry, :many?
    assert_predicate episodes(limit: 1), :one?
  end

  test "#episodes orders the number of Episodes by default" do
    episodes = self.episodes
    assert_equal episodes, episodes.sort_by(&:published_at).reverse
  end

  test "#episodes order can be customized" do
    episodes = episodes order: {published_at: :asc}
    assert_equal episodes, episodes.sort_by(&:published_at)
  end

  private

  def episodes(entries: feeds.one.entries, user: @user, **)
    Episode::Collection.new(entries:, user:, **).episodes
  end
end
