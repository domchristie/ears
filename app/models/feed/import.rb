class Feed::Import < Import
  belongs_to :feed, foreign_type: :resource_type, foreign_key: :resource_id, polymorphic: true

  def start!
    super do
      log("Fetching Feed #{feed.id}")
      fetch = Feed::Import::Fetch.start!(feed:, conditional:, import: self)

      if fetch.success?
        load(Feed::Import::Transform.data(fetch))
        success!
      elsif fetch.not_modified?
        not_modified!
        log("Feed #{feed.id} Not Modified")
      elsif fetch.error?
        error!
        log("Feed #{feed.id} Fetch Error: #{fetch.error}")
      end

      clean
    end
  end

  private

  def load(data)
    feed.update!(data.without(:entries_attributes, :rss_image_attributes))
    load_entries(data[:entries_attributes])
    load_rss_image(data[:rss_image_attributes])
  end

  def load_entries(entries_attributes)
    if entries_attributes.present?
      Entry.upsert_all(
        entries_attributes,
        unique_by: [:feed_id, :formatted_guid],
        record_timestamps: true
      )
    end
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

  def clean
    if success?
      feed.imports.where("created_at < ?", created_at).destroy_all
    else
      feed.imports
        .where("created_at < ?", created_at)
        .where.not(id: feed.recent_successful_or_not_modified_import&.id)
        .destroy_all
    end
  end
end
