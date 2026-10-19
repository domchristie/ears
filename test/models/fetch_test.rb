require "test_helper"

class FetchTest < ActiveSupport::TestCase
  setup do
    @url = "http://example.com/feed"
    @last_modified = 1.day.ago.to_fs(:rfc7231)
  end

  test "redirect keeps safe request headers" do
    stub_request(:get, @url).to_return(status: 301, headers: {location: "http://example.com/new"})
    stub_request(:get, "http://example.com/new").to_return(status: 200)

    Fetch.start(conditional_request(@url))

    assert_requested :get, "http://example.com/new", headers: expected_headers
  end

  test "cross-origin redirect keeps safe request headers" do
    stub_request(:get, @url).to_return(status: 301, headers: {location: "https://other.example.com/feed"})
    stub_request(:get, "https://other.example.com/feed").to_return(status: 200)

    Fetch.start(conditional_request(@url))

    assert_requested :get, "https://other.example.com/feed", headers: expected_headers
  end

  private

  def conditional_request(url)
    Net::HTTP::Get.new(URI(url)).tap do |request|
      request["If-None-Match"] = "test_etag"
      request["If-Modified-Since"] = @last_modified
    end
  end

  def expected_headers
    {
      "User-Agent" => "Ears/1.0 +https://www.ears.app",
      "If-None-Match" => "test_etag",
      "If-Modified-Since" => @last_modified
    }
  end
end
