require "test_helper"

class ItunesSearchTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as users.one
  end

  test "searching" do
    stub_request(:get, "http://itunes.apple.com/search?media=podcast&term=hello")
      .to_return(status: 200, body: itunes_search_response_body)

    get directories_search_path(term: "hello")

    assert_select "article a[href='#{itunes_feed_path(1)}']", "All About Everything"
  end

  test "showing a search result" do
    stub_request(:get, "https://itunes.apple.com/lookup?id=1&entity=podcast")
      .to_return(status: 200, body: itunes_search_response_body)
    stub_request(:get, "http://feeds.example.com")
      .to_return(status: 200, body: file_fixture("feed.xml"))

    get itunes_feed_path(1)

    assert_response :see_other
    follow_redirect!
    assert_select "h1", "All About Everything"
  end

  private

  def itunes_search_response_body
    {
      resultCount: 1,
      results: [{
        artworkUrl600: "http://example.com/image.jpg",
        collectionName: "All About Everything",
        artistName: "John Doe",
        collectionId: 1,
        feedUrl: "http://feeds.example.com"
      }]
    }.to_json
  end
end
