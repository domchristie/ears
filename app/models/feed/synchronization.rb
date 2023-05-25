class Feed::Synchronization < Synchronization
  belongs_to :feed, foreign_type: :resource_type, foreign_key: :resource_id, polymorphic: true

  def start!
    super do
      log("Fetching Feed #{feed.id}")
      fetch = Feed::Fetch.start!(feed:, conditional:, synchronization: self)

      if fetch.success?
        Feed::Import.start!(feed:, data: fetch.response_body, synchronization: self)
        update_feed(fetch)
      elsif fetch.not_modified?
        log("Feed #{feed.id} Not Modified")
      elsif fetch.error?
        log("Feed #{feed.id} Fetch Error: #{fetch.error}")
      end
    end
  end

  private

  def update_feed(fetch)
    updates = ["conditional request", ("url" if fetch.redirected_permanently?)].compact
    log("Updating Feed #{feed.id} #{updates.to_sentence} attributes")

    feed.update!({
      last_modified_at: fetch.response_headers["last-modified"],
      etag: fetch.response_headers["etag"],
      url: (fetch.uri if fetch.redirected_permanently?)
    }.compact_blank)
  end
end
