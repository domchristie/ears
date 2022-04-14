class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_one :rss_image, as: :rss_imageable

  def author
    itunes_author || managing_editor
  end

  def sync!
    get = self.get
    checked_at = Time.now.utc
    import! parse(get.body) unless get.response.is_a?(Net::HTTPNotModified)
    update!(last_checked_at: checked_at)
  end

  def import!(remote_feed)
    Feed.upsert(
      self.class.attributes_for_import(remote_feed).merge(id: id),
      unique_by: :id,
      record_timestamps: true
    )
    RssImage.import!(Feed, id, remote_feed.image) if remote_feed.image
    Entry.import_all!(id, remote_feed.entries) if remote_feed.entries.try(:any?)
  end

  def parse(xml)
    Feedjira.parse(xml, parser: Feedjira::Parser::ITunesRSS)
  end

  def get
    HTTParty.get(url, headers: {
      "If-Modified-Since": last_checked_at.try(:to_fs, :rfc7231)
    })
  end

  def self.attributes_for_import(remote_feed)
    {
      copyright: remote_feed.copyright,
      description: remote_feed.description,
      language: remote_feed.language,
      last_build_at: remote_feed.last_built,
      website_url: remote_feed.url,
      managing_editor: remote_feed.managing_editor,
      title: remote_feed.title,
      ttl: remote_feed.ttl,
      itunes_author: remote_feed.itunes_author,
      itunes_block: remote_feed.itunes_block == "Yes",
      itunes_image: remote_feed.itunes_image,
      itunes_explicit: remote_feed.itunes_explicit == "true",
      itunes_complete: remote_feed.itunes_complete == "Yes",
      itunes_keywords: remote_feed.itunes_keywords,
      itunes_type: remote_feed.itunes_type,
      itunes_new_feed_url: remote_feed.itunes_new_feed_url,
      itunes_subtitle: remote_feed.itunes_subtitle,
      itunes_summary: remote_feed.itunes_summary
    }
  end
end
