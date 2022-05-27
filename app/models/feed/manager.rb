class Feed::Manager
  def self.parse(rss)
    Feedjira.parse(rss, parser: Feedjira::Parser::ITunesRSS)
  end

  def self.fetch(feed, conditional: true)
    headers = if conditional
      {
        "If-Modified-Since": feed.last_modified_at.try(:to_fs, :rfc7231),
        "If-None-Match": feed.etag
      }
    end

    HTTParty.get(feed.url, headers: headers)
  end
end
