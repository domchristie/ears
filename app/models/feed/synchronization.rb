class Feed::Synchronization < Synchronization
  belongs_to :feed, foreign_type: :resource_type, foreign_key: :resource_id, polymorphic: true

  def self.start!(...)
    new(...).start!
  end

  def start!
    log("Fetching Feed #{feed.id}")
    update!(
      fetch: Feed::Fetch.start!(feed:, conditional:),
      started_at: Time.current
    )

    if fetch.success?
      import_feed
      update_feed
    elsif fetch.not_modified?
      log("Feed #{feed.id} Not Modified")
    elsif fetch.error?
      log("Feed #{feed.id} Fetch Error: #{fetch.error}")
    end

    update!(finished_at: Time.current)
  end

  private

  def update_feed
    updates = ["conditional request", ("url" if fetch.redirected_permanently?)].compact
    log("Updating Feed #{feed.id} #{updates.to_sentence} attributes")

    feed.update!({
      last_modified_at: fetch.response_headers["last-modified"],
      etag: fetch.response_headers["etag"],
      url: (fetch.uri if fetch.redirected_permanently?)
    }.compact_blank)
  end

  def import_feed
    log("Importing Feed #{feed.id}")
    # update!(import: Feed::Import.start!(feed:, fetch:))
    ImportFeedJob.perform_now(
      feed,
      remote_feed: Feed::Manager.parse(fetch.response_body),
      source: :rake
    )
  end
end
