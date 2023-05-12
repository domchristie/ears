require "test_helper"

class FeedSynchronizationTest < ActionDispatch::IntegrationTest
  setup do
    @feed = feeds(:one)
  end

  test "successful synchronization" do
    file = Rails.root.join("test", "fixtures", "files", "feed.xml")
    stub_request(:get, @feed.url).to_return(status: 200, body: File.read(file))

    assert_difference -> { Entry.count }, 3 do
      Feed::Synchronization.start!(feed: @feed, source: :test)
    end
  end

  test "not modified synchronization" do
    stub_request(:get, @feed.url).to_return(status: 301)

    assert_no_difference -> { Entry.count } do
      Feed::Synchronization.start!(feed: @feed, source: :test)
    end
  end

  test "unsuccessful synchronization" do
    stub_request(:get, @feed.url).to_return(status: 404)

    assert_no_difference -> { Entry.count } do
      Feed::Synchronization.start!(feed: @feed, source: :test)
    end
  end
end
