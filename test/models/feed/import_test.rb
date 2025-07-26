require "test_helper"

class FeedImportTest < ActiveSupport::TestCase
  setup do
    @feed = feeds.one
  end

  test "successful import" do
    file = Rails.root.join("test", "fixtures", "files", "feed.xml")
    now = Time.current
    stub_request(:get, @feed.url).to_return(
      status: 200,
      headers: {last_modified: now.to_fs(:db), etag: "test_etag"},
      body: File.read(file)
    )

    assert_difference -> { Entry.count }, 3 do
      Feed::Import.start(feed: @feed, source: :test)
      assert_in_delta now, @feed.last_modified_at, 1
      assert_equal "test_etag", @feed.etag
    end
  end

  test "successful redirected import" do
    file = Rails.root.join("test", "fixtures", "files", "feed.xml")
    redirect_location = "http://new.example.com"
    stub_request(:get, @feed.url).to_return(
      status: 301,
      headers: {location: redirect_location}
    )
    stub_request(:get, redirect_location).to_return(
      status: 200,
      body: File.read(file)
    )

    assert_difference -> { Entry.count }, 3 do
      Feed::Import.start(feed: @feed, source: :test)
      assert_equal redirect_location, @feed.url
    end
  end

  test "not modified import" do
    stub_request(:get, @feed.url).to_return(status: 304)

    assert_no_difference -> { Entry.count } do
      Feed::Import.start(feed: @feed, source: :test)
    end
  end

  test "unsuccessful import" do
    stub_request(:get, @feed.url).to_return(status: 404)

    assert_no_difference -> { Entry.count } do
      Feed::Import.start(feed: @feed, source: :test)
    end
  end
end
