require "test_helper"

class FeedTest < ActiveSupport::TestCase
  test "destroying related records" do
    feed = feeds.one
    id = feed.id

    assert feed.entries.any?
    assert feed.plays.any?
    assert feed.web_subs.any?
    assert feed.imports.any?
    assert feed.extractions.any?
    assert feed.rss_image.present?

    feed.destroy!

    assert feed.entries.none?
    assert feed.plays.none?
    assert feed.web_subs.none?
    assert feed.imports.none?
    assert feed.extractions.none?
    refute RssImage.find_by(rss_imageable_type: "Feed", rss_imageable_id: id)
  end
end
