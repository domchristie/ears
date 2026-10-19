require "test_helper"

class Feed::WebSubsTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @feed = Feed.create!(
      title: "All About Everything",
      url: "http://feeds.example.com/all-about-everything",
      web_sub_hub_url: "https://websub.example.com/"
    )
    @feed.web_subs.delete_all
  end

  test "changing the hub replaces the subscription" do
    old_web_sub = @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 5.days.from_now)

    assert_enqueued_jobs(1, only: StartWebSubJob) do
      @feed.update!(web_sub_hub_url: "https://other-websub.example.com/")
    end

    assert_raises(ActiveRecord::RecordNotFound) { old_web_sub.reload }
    assert_equal ["https://other-websub.example.com/"], @feed.web_subs.reload.pluck(:hub_url)
  end

  test "renewal due without any subscriptions" do
    assert_renewal_due
  end

  test "renewal not due with a subscription not expiring soon" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 5.days.from_now)
    assert_renewal_not_due
  end

  test "renewal due when the subscription is expiring" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 2.hours.from_now)
    assert_renewal_due
  end

  test "renewal due when the subscription has expired" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 1.day.ago)
    assert_renewal_due
  end

  test "renewal not due while awaiting verification" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, created_at: 10.minutes.ago)
    assert_renewal_not_due
  end

  test "renewal due when verification never arrived" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, created_at: 2.hours.ago)
    assert_renewal_due
  end

  test "renewal not due without a hub" do
    @feed.update!(web_sub_hub_url: nil)
    assert_renewal_not_due
  end

  test "renewal not due when any subscription is not expiring soon" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 1.day.ago)
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 5.days.from_now)

    assert_renewal_not_due
  end

  test "renewing uses the feed's current hub" do
    @feed.web_subs.create!(hub_url: "https://websub.example.com", expires_at: 1.day.ago)

    Feed.renew_web_subs

    assert_equal "https://websub.example.com/", @feed.web_subs.reload.last.hub_url
  end

  test "renewing only affects feeds that are due" do
    other_feed = Feed.create!(
      title: "Another Podcast",
      url: "http://feeds.example.com/another-podcast",
      web_sub_hub_url: "https://websub.example.com/"
    )
    other_feed.web_subs.delete_all
    other_feed.web_subs.create!(hub_url: other_feed.web_sub_hub_url, expires_at: 5.days.from_now)
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 1.day.ago)

    assert_no_difference("other_feed.web_subs.count") do
      assert_difference("@feed.web_subs.count", 1) { Feed.renew_web_subs }
    end
  end

  test "renewing creates one subscription per feed" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 1.day.ago)
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 2.days.ago)

    assert_difference("@feed.web_subs.count", 1) do
      assert_enqueued_jobs(1, only: StartWebSubJob) do
        Feed.renew_web_subs
        Feed.renew_web_subs
      end
    end
  end

  test "sync due without a subscription, even when recently imported" do
    import_at 1.hour.ago
    assert_sync_due
  end

  test "sync not due with an active subscription and a recent import" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 5.days.from_now)
    import_at 1.hour.ago
    assert_sync_not_due
  end

  test "sync due with an active subscription and an old import" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 5.days.from_now)
    import_at 7.hours.ago
    assert_sync_due
  end

  test "sync due with an active subscription and no import" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 5.days.from_now)
    assert_sync_due
  end

  test "sync due with an expired subscription and a recent import" do
    @feed.web_subs.create!(hub_url: @feed.web_sub_hub_url, expires_at: 1.day.ago)
    import_at 1.hour.ago
    assert_sync_due
  end

  private

  def import_at(time)
    Feed::Import.create!(resource: @feed, source: "rake", started_at: time, finished_at: time)
  end

  def assert_sync_due
    assert_includes Feed.sync_due, @feed
  end

  def assert_sync_not_due
    assert_not_includes Feed.sync_due, @feed
  end

  def assert_renewal_due
    assert_includes Feed.web_sub_renewal_due, @feed
  end

  def assert_renewal_not_due
    assert_not_includes Feed.web_sub_renewal_due, @feed
  end
end
