class ImportFeedJob < ApplicationJob
  queue_as :default

  def perform(feed, remote_feed:, source:, at: nil)
    attributes = Feed.attributes_for_import(remote_feed)
    attributes[:import_source] = source
    attributes[:last_checked_at] = at if at
    feed.update!(attributes)

    if remote_feed.image
      RssImage.import!(Feed, feed.id, remote_feed.image)
    end

    if remote_feed.entries.try(:any?)
      Entry.import_all!(feed.id, remote_feed.entries)
    end
  end
end
