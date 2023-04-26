class SyncFeedJob < ApplicationJob
  queue_as :default

  def perform(feed, source:, force: false)
    log "Fetching Feed #{feed.id}, source: #{source}, force: #{force}"

    fetch = Feed::Fetch.start!(resource: feed, conditional: !force)

    if fetch.success?
      log "Importing Feed #{feed.id}"

      if fetch.redirected_permanently? && feed.web_subable?
        feed.web_subs.destroy_all
      end

      feed.update!({
        last_modified_at: fetch.response_headers["last-modified"],
        etag: fetch.response_headers["etag"],
        url: (fetch.uri if fetch.redirected_permanently?)
      }.compact_blank)

      if fetch.redirected_permanently? && feed.web_subable?
        feed.start_web_sub
      end

      ImportFeedJob.perform_now(
        feed,
        remote_feed: Feed::Manager.parse(fetch.response_body),
        source: source
      )
      nil
    elsif fetch.not_modified?
      log "Feed #{feed.id} not modified, doing nothing"
    end

    nil
  end

  private

  def log(message)
    puts "[#{self.class}] #{message}"
  end
end
