class Feed::Import < Import
  RESPONSE_HEADERS = %w[
    location
    etag
    last-modified
    cache-control
    expires
    content-type
    content-length
    content-encoding
    server
    via
  ]

  def feed = resource

  def feed=(feed)
    self.resource = feed
  end

  def extract
    Extraction.start_with_fetch(resource:, fetch:) do |fetch|
      {
        body: fetch.response.body,
        responses: fetch.responses.map { |response| response_hash(response) },
        response_codes: fetch.responses.map { |response| response.code.to_i },
      }
    end
  end

  def transform
    Transform.data(extraction)
  end

  def load(data)
    Feed.transaction do
      feed.entries.update_all(in_latest_feed: false)
      feed.update!(data)
    end
  end

  private

  def fetch = Fetch.new(request)

  def request
    Net::HTTP::Get.new(URI(feed.url)).tap do |request|
      request["If-Modified-Since"] = feed.last_modified_at.try(:to_fs, :rfc7231)
      request["If-None-Match"] = feed.etag
    end
  end

  def response_hash(response)
    response.to_hash.slice(*RESPONSE_HEADERS)
  end
end
