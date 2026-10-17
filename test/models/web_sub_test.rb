require "test_helper"

class WebSubTest < ActiveSupport::TestCase
  setup do
    feed = Feed.create!(
      title: "All About Everything",
      url: "http://feeds.example.com/all-about-everything",
      web_sub_hub_url: "https://websub.example.com/"
    )
    @web_sub = feed.web_subs.first
  end

  test "start succeeds when the hub accepts the request" do
    stub_request(:post, @web_sub.hub_url).to_return(status: 202)

    assert_nothing_raised { @web_sub.start }
  end

  test "start raises when the hub rejects the request" do
    stub_request(:post, @web_sub.hub_url).to_return(status: 503)

    error = assert_raises(WebSub::RequestFailed) { @web_sub.start }
    assert_match "503", error.message
  end

  test "confirming sets the expiry from the time of verification" do
    travel 1.day
    freeze_time

    @web_sub.confirm!(5.days.to_i)

    assert_equal 5.days.from_now, @web_sub.expires_at
  end

  test "confirming replaces older subscriptions, whichever hub they used" do
    older = @web_sub
    older.update!(hub_url: "https://websub.example.com")
    newer = older.feed.web_subs.create!(hub_url: "https://websub.example.com/")

    newer.confirm!(5.days.to_i)

    assert_raises(ActiveRecord::RecordNotFound) { older.reload }
  end

  test "a late verification of an older subscription keeps the newer one" do
    older = @web_sub
    newer = older.feed.web_subs.create!(hub_url: older.hub_url)
    newer.confirm!(5.days.to_i)

    older.confirm!(5.days.to_i)

    assert_nothing_raised { newer.reload }
  end
end
