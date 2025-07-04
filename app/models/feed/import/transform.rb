class Feed::Import::Transform < Import::Transform
  def data
    @data ||= {
      last_modified_at: fetch.response_headers["last-modified"],
      etag: fetch.response_headers["etag"],
      url: fetch.new_permanent_location,

      web_sub_hub_url: parsed.hubs.first,
      copyright: parsed.copyright,
      description: parsed.description,
      language: parsed.language,
      last_built_at: parsed.last_built,
      website_url: parsed.url,
      managing_editor: parsed.managing_editor,
      title: parsed.title,
      ttl: parsed.ttl,
      itunes_author: parsed.itunes_author,
      itunes_block: parsed.itunes_block&.downcase == "yes",
      itunes_image: parsed.itunes_image,
      itunes_explicit: parsed.itunes_explicit&.downcase == "true",
      itunes_complete: parsed.itunes_complete&.downcase == "yes",
      itunes_keywords: parsed.itunes_keywords,
      itunes_type: parsed.itunes_type,
      itunes_new_feed_url: parsed.itunes_new_feed_url,
      itunes_subtitle: parsed.itunes_subtitle,
      itunes_summary: parsed.itunes_summary,

      entries_attributes:,
      rss_image_attributes:
    }.compact_blank
  end

  private

  def fetch
    @source
  end

  def feed
    @feed ||= fetch.feed
  end

  def parsed
    @parsed ||= Feed.parse(fetch.response_body)
  end

  def entries_attributes
    (parsed.entries || [])
      .map { |parsed_entry| entry_attributes(parsed_entry) }
      .compact_blank
  end

  def entry_attributes(parsed_entry)
    Entry::Import::Transform.data(parsed_entry).tap do |attributes|
      if attributes.present?
        attributes.merge!(feed_id: feed.id, in_latest_feed: true)
      end
    end
  end

  def rss_image_attributes
    RssImage::Import::Transform.data(parsed.image).tap do |attributes|
      if attributes.present?
        attributes.merge!(rss_imageable_type: Feed, rss_imageable_id: feed.id)
      end
    end
  end
end
