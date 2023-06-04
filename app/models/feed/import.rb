class Feed::Import < Import
  belongs_to :feed, foreign_type: :resource_type, foreign_key: :resource_id, polymorphic: true

  def start!
    super do
      log("Fetching Feed #{feed.id}")
      fetch = Feed::Import::Fetch.start!(feed:, conditional:, import: self)

      if fetch.success?
        transform = Feed::Import::Transform.new(fetch, resource: feed)
        load(transform.data)
      elsif fetch.not_modified?
        log("Feed #{feed.id} Not Modified")
      elsif fetch.error?
        log("Feed #{feed.id} Fetch Error: #{fetch.error}")
      end
    end
  end

  private

  def load(data)
    feed.update!(data.without(:entries_attributes, :rss_image_attributes))
    load_entries(data[:entries_attributes])
    load_rss_image(data[:rss_image_attributes])
  end

  def load_entries(entries_attributes)
    Entry.upsert_all(
      entries_attributes,
      unique_by: [:feed_id, :formatted_guid],
      record_timestamps: true
    )
  end

  def load_rss_image(rss_image_attributes)
    if rss_image_attributes.present?
      RssImage.upsert(
        rss_image_attributes,
        unique_by: [:rss_imageable_type, :rss_imageable_id],
        record_timestamps: true
      )
    end
  end
end
