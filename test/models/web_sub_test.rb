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
end
