require "test_helper"

class FeedImportTest < ActiveSupport::TestCase
  setup do
    @feed = feeds.one
  end

  test "successful import" do
    now = Time.current
    stub_request(:get, @feed.url).to_return(
      status: 200,
      headers: {last_modified: now.to_fs(:db), etag: "test_etag"},
      body: file_fixture("feed.xml")
    )

    assert_difference -> { Entry.count }, 3 do
      Feed::Import.start(feed: @feed, source: :test)
      assert_in_delta now, @feed.last_modified_at, 1
      assert_equal "test_etag", @feed.etag
    end
  end

  test "successful redirected import" do
    redirect_location = "http://new.example.com"
    stub_request(:get, @feed.url).to_return(
      status: 301,
      headers: {location: redirect_location}
    )
    stub_request(:get, redirect_location).to_return(
      status: 200,
      body: file_fixture("feed.xml")
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

  test "not modified redirected import" do
    @feed.update!(etag: "test_etag", last_modified_at: 1.day.ago)
    redirect_location = "http://new.example.com"
    stub_request(:get, @feed.url).to_return(
      status: 301,
      headers: {location: redirect_location}
    )
    stub_request(:get, redirect_location)
      .with(headers: {"If-None-Match" => "test_etag"})
      .to_return(status: 304)

    assert_no_difference -> { Entry.count } do
      import = Feed::Import.start(feed: @feed, source: :test)
      assert import.not_modified?
    end
  end

  test "unsuccessful import" do
    stub_request(:get, @feed.url).to_return(status: 404)

    assert_no_difference -> { Entry.count } do
      Feed::Import.start(feed: @feed, source: :test)
    end
  end

  test "import clears the hub when the feed no longer lists one" do
    @feed.update_column(:web_sub_hub_url, "https://websub.example.com/")
    assert @feed.web_subs.any?
    stub_request(:get, @feed.url).to_return(status: 200, body: file_fixture("feed.xml"))

    Feed::Import.start(feed: @feed, source: :test)

    assert_nil @feed.reload.web_sub_hub_url
    assert @feed.web_subs.none?
  end

  test "not found import clears the hub" do
    @feed.update_column(:web_sub_hub_url, "https://websub.example.com/")
    assert @feed.web_subs.any?
    stub_request(:get, @feed.url).to_return(status: 404)

    Feed::Import.start(feed: @feed, source: :test)

    assert_nil @feed.reload.web_sub_hub_url
    assert @feed.web_subs.none?
  end

  test "import saves false when a flag changes to no" do
    @feed.update_column(:itunes_complete, true)
    body = file_fixture("feed.xml").read
      .sub("<channel>", "<channel><itunes:complete>No</itunes:complete>")
    stub_request(:get, @feed.url).to_return(status: 200, body:)

    Feed::Import.start(feed: @feed, source: :test)

    assert_equal false, @feed.reload.itunes_complete
  end

  test "import clears a field that the feed removed" do
    @feed.update_column(:ttl, 60)
    stub_request(:get, @feed.url).to_return(status: 200, body: file_fixture("feed.xml"))

    Feed::Import.start(feed: @feed, source: :test)

    assert_nil @feed.reload.ttl
  end

  test "import without a redirect keeps the url" do
    url = @feed.url
    stub_request(:get, url).to_return(status: 200, body: file_fixture("feed.xml"))

    Feed::Import.start(feed: @feed, source: :test)

    assert_equal url, @feed.reload.url
  end

  test "import saves blank values as nil" do
    body = file_fixture("feed.xml").read
      .sub("<title>All About Everything</title>", "<title> </title>")
      .sub("<channel>", %(<channel><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="hub" href=""/>))
    stub_request(:get, @feed.url).to_return(status: 200, body:)

    Feed::Import.start(feed: @feed, source: :test)

    assert_nil @feed.reload.title
    assert_nil @feed.web_sub_hub_url
  end
end
