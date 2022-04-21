class Feed::Manager
  def self.parse(rss)
    Feedjira.parse(rss, parser: Feedjira::Parser::ITunesRSS)
  end

  def self.fetch(feed)
    HTTParty.get(feed.url, headers: {
      "If-Modified-Since": feed.last_checked_at.try(:to_fs, :rfc7231)
    })
  end
end
