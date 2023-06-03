class ImportOpmlJob < ApplicationJob
  queue_as :default

  def perform(opml_import, user)
    doc = Nokogiri::XML.parse(opml_import.temp_file)
    feeds_ids = upsert_feeds(doc.css("outline"))
    upsert_followings(feeds_ids, user)
    import_feeds(feeds_ids)
    opml_import.destroy!
  end

  private

  def upsert_feeds(outlines)
    Feed.upsert_all(
      feeds_attributes(outlines),
      unique_by: :url,
      returning: :id
    ).pluck("id")
  end

  def upsert_followings(feeds_ids, user)
    Following.upsert_all(
      followings_attributes(feeds_ids, user),
      unique_by: [:feed_id, :user_id]
    )
  end

  def import_feeds(feed_ids)
    Feed.where(id: feed_ids).find_each do |feed|
      SyncFeedJob.perform_now(feed, source: :opml_import)
    end
  end

  def feeds_attributes(outlines)
    outlines.map { |outline| feed_attributes(outline) }
  end

  def feed_attributes(outline)
    {
      url: outline.attr("xmlUrl"),
      title: outline.attr("title").presence || outline.attr("text")
    }
  end

  def followings_attributes(feed_ids, user)
    feed_ids.map { |feed_id| following_attributes(feed_id, user) }
  end

  def following_attributes(feed_id, user)
    {feed_id: feed_id, user_id: user.id}
  end
end
