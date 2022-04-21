require "test_helper"
class WebSubTest < ActionDispatch::IntegrationTest
  test "successful subscription" do
    web_sub = web_subs(:one)

    # SUBSCRIBER SENDS SUBSCRIPTION REQUEST
    stub_request(:post, web_sub.hub_url).to_return(status: 202)
    WebSub::Manager.start(web_sub)

    assert_requested(
      :post,
      web_sub.hub_url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "hub.callback": web_sub_feed_url(web_sub),
        "hub.mode": "subscribe",
        "hub.topic": web_sub.feed.url,
        "hub.secret": web_sub.secret
      }
    )

    # HUB VERIFIES INTENT OF THE SUBSCRIBER
    challenge = "hub-generated-random-string"
    lease_seconds = 10.days.to_i
    job_scheduled_at = web_sub.created_at + lease_seconds - 6.hours

    assert_enqueued_with(job: RenewWebSubJob, args: [web_sub], at: job_scheduled_at) do
      get web_sub_feed_url(
        web_sub,
        "hub.mode": "subscribe",
        "hub.topic": web_sub.feed.url,
        "hub.challenge": challenge,
        "hub.lease_seconds": lease_seconds
      )
    end

    assert_response :ok
    assert_equal challenge, response.body
    assert_equal(
      web_sub.created_at + lease_seconds,
      web_sub.reload.expires_at
    )

    # Re-request subscription: create new WebSub
    assert_difference "WebSub.count" do
      perform_enqueued_jobs at: web_sub.expires_at
    end

    new_web_sub = WebSub.order(created_at: :asc).last

    assert_requested(
      :post,
      new_web_sub.hub_url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "hub.callback": web_sub_feed_url(new_web_sub),
        "hub.mode": "subscribe",
        "hub.topic": new_web_sub.feed.url,
        "hub.secret": new_web_sub.secret
      }
    )

    # Remove expiring WebSub
    assert_difference "WebSub.count", -1 do
      get web_sub_feed_url(
        new_web_sub,
        "hub.mode": "subscribe",
        "hub.topic": new_web_sub.feed.url,
        "hub.challenge": challenge,
        "hub.lease_seconds": lease_seconds
      )
    end
    assert_raise(ActiveRecord::RecordNotFound) { web_sub.reload }

    # CONTENT DISTRIBUTION
    file = Rails.root.join("test", "fixtures", "files", "feed.xml")
    stub_request(:get, new_web_sub.feed_url)
      .to_return(
        status: 200,
        body: File.read(file)
      )

    assert_enqueued_with(job: SyncFeedJob) do
      post(web_sub_feed_url(new_web_sub), headers: {
        "X-Hub-Signature": "sha1=#{Digest::SHA1.hexdigest(new_web_sub.secret)}"
      })
    end

    assert_difference "Entry.count", 3 do
      perform_enqueued_jobs
    end
  end
end
