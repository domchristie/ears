class Feed::Fetch < Fetch
  belongs_to :feed, foreign_type: :resource_type, foreign_key: :resource_id, polymorphic: true

  def self.start!(...)
    new(...).start!
  end

  def start!
    if conditional?
      request_headers["If-Modified-Since"] = feed.last_modified_at.try(:to_fs, :rfc7231)
      request_headers["If-None-Match"] = feed.etag
    end

    update!(started_at: Time.current)
    get(feed.url)
    update!(finished_at: Time.current)
    self
  end
end
