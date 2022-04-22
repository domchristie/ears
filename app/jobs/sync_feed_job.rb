class SyncFeedJob < ApplicationJob
  queue_as :default

  def perform(feed, source:)
    at = Time.now.utc
    get = Feed::Manager.fetch(feed)

    case get.response
    when Net::HTTPSuccess
      ImportFeedJob.perform_now(
        feed,
        remote_feed: Feed::Manager.parse(get.body),
        source: source,
        at: at
      )
    when Net::HTTPTemporaryRedirect, Net::HTTPMovedPermanently
      puts "TODO: update feed_url, enqueue SyncFeedJob; feed id: #{feed.id}"
    when Net::HTTPClientError
      puts "TODO: mark as gone?"
    end
  end
end
