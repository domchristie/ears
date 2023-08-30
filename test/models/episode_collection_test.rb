require "test_helper"

class EpisodeCollectionTest < ActiveSupport::TestCase
  setup do
    @entries = feeds(:one).entries
    @user = users(:one)
  end

  test "#episodes returns a list of Episodes" do
    episodes_collection = EpisodeCollection.new(entries: @entries, user: @user)
    assert episodes_collection.episodes.all? { |e| e.is_a? Episode }
  end

  test "#episodes only contain the user's plays" do
    episodes_collection = EpisodeCollection.new(entries: @entries, user: @user)
    assert episodes_collection.episodes.any? { |e| e.play.persisted? }
    assert episodes_collection.episodes.all? { |e| e.play.user = @user }
  end

  test "#episodes limits the number of Episodes" do
    episodes_collection = EpisodeCollection.new(entries: @entries, user: @user, limit: 1)

    assert_operator entries.count, :>, 1
    assert_equal 1, episodes_collection.episodes.count
  end

  test "#episodes orders the number of Episodes by default" do
    episodes_collection = EpisodeCollection.new(entries: @entries, user: @user)
    episodes = episodes_collection.episodes

    assert_operator episodes[0].published_at, :>, episodes[1].published_at
  end

  test "#episodes order can be customized" do
    episodes_collection = EpisodeCollection.new(entries: @entries, user: @user, order: {published_at: :asc})
    episodes = episodes_collection.episodes

    assert_operator episodes[0].published_at, :<, episodes[1].published_at
  end
end
