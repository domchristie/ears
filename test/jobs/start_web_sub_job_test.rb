require "test_helper"

class StartWebSubJobTest < ActiveJob::TestCase
  test "discarded when the WebSub was deleted before the job ran" do
    feed = Feed.create!(
      title: "All About Everything",
      url: "http://feeds.example.com/all-about-everything",
      web_sub_hub_url: "https://websub.example.com/"
    )

    # e.g. a newer subscription was confirmed, deleting this one
    feed.web_subs.delete_all

    assert_nothing_raised { perform_enqueued_jobs }
    assert_not_requested :post, feed.web_sub_hub_url
  end

  test "not retried when the hub rejects the request" do
    feed = Feed.create!(
      title: "All About Everything",
      url: "http://feeds.example.com/all-about-everything",
      web_sub_hub_url: "https://websub.example.com/"
    )
    stub_request(:post, feed.web_sub_hub_url).to_return(status: 422)

    assert_raises(WebSub::ClientError) { perform_enqueued_jobs }
    assert_no_enqueued_jobs(only: StartWebSubJob)
    assert_requested :post, feed.web_sub_hub_url, times: 1
  end
end
