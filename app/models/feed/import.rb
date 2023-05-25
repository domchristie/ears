class Feed::Import < Import
  belongs_to :feed, foreign_type: :resource_type, foreign_key: :resource_id, polymorphic: true

  def start!
    super do
      feed.update!(feed_attributes)

      if remote_feed.image
        RssImage.import!(Feed, feed.id, remote_feed.image)
      end

      if remote_feed.entries.try(:any?)
        Entry.import_all!(feed.id, remote_feed.entries)
      end
    end
  end

  private

  def remote_feed
    @remote_feed = Feed::Manager.parse(data)
  end

  def feed_attributes
    @feed_attributes ||= {
      web_sub_hub_url: remote_feed.hubs.first,
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
