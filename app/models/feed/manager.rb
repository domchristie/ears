class Feed::Manager
  def self.parse(rss)
    Feedjira.parse(rss, parser: Feedjira::Parser::ITunesRSS)
  end

  def self.fetch(feed, conditional: true)
    HTTParty.get(feed.url, headers: {
      "If-Modified-Since": (
        feed.last_checked_at.try(:to_fs, :rfc7231) if conditional
      )
    })
  end
end
