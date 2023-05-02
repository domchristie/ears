require "test_helper"

class FeedTest < ActiveSupport::TestCase
  test "destroying related records" do
    feed = feeds(:one)
    Feed::Synchronization.create!(
      feed:,
      fetch: Feed::Fetch.create!(feed:),
      source: :test
    )
    assert feed.entries.any?
    assert feed.plays.any?
    assert feed.web_subs.any?
    assert feed.synchronizations.any?
    assert feed.fetches.any?

    feed.destroy!

    assert feed.entries.none?
    assert feed.plays.none?
    assert feed.web_subs.none?
    assert feed.synchronizations.none?
    assert feed.fetches.none?
  end
end
