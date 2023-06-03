require "test_helper"

class ImportOpmlJobTest < ActiveJob::TestCase
  setup do
    @user = users(:one)
    @opml_import = opml_imports(:valid)

    rss_fixture = Rails.root.join("test", "fixtures", "files", "feed.xml")
    stub_request(:get, "http://feeds.wnyc.org/radiolab")
      .to_return(status: 200, body: File.read(rss_fixture))
    stub_request(:get, "https://feeds.simplecast.com/BqbsxVfO")
      .to_return(status: 200, body: File.read(rss_fixture))
  end

  test "#perform creates feeds if they don't exist" do
    assert_difference "Feed.count", 2 do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end

    assert_no_difference "Feed.count" do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end
  end

  test "#perform creates followings if they don't exist" do
    assert_difference "Following.count", 2 do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end

    assert_no_difference "Following.count" do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end
  end
end
