class SyncFeedJob < ApplicationJob
  queue_as :default

  def perform(feed, source:)
    at = Time.now.utc
    get = Feed::Manager.fetch(feed)

    if get.response.is_a?(Net::HTTPSuccess)
      ImportFeedJob.perform_now(
        feed,
        remote_feed: Feed::Manager.parse(get.body),
        source: source,
        at: at
      )
    end
  end
end
