class SyncFeedJob < ApplicationJob
  queue_as :default

  def perform(feed, source:, force: false)
    Rails.logger.info(
      "[#{self.class}] starting; feed: #{feed.id}, source: #{source}, force: #{force}"
    )
    at = Time.now.utc
    get = Feed::Manager.fetch(feed, conditional: !force)

    feed.update!(
      last_modified_at: get.headers["last-modified"],
      etag: get.headers["etag"]
    )

    case get.response
    when Net::HTTPSuccess
      ImportFeedJob.perform_now(
        feed,
        remote_feed: Feed::Manager.parse(get.body),
        source: source,
        at: at
      )
      nil
    when Net::HTTPNotModified
      puts "[#{self.class}] feed: #{feed.id} Net::HTTPNotModified"
    when Net::HTTPTemporaryRedirect, Net::HTTPMovedPermanently
      puts "[#{self.class}] feed: #{feed.id} #{get.response.class}"
      # TODO: update feed_url, enqueue SyncFeedJob
    when Net::HTTPClientError
      puts "[#{self.class}] feed: #{feed.id} #{get.response.class}"
      # TODO: mark as gone?
    end
  end
end
