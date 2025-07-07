class Feed::Import < Import
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
      elsif fetch.not_found?
        not_found!
        log("Feed #{feed.id} Not Found")
      elsif fetch.error?
        error!
        log("Feed #{feed.id} Fetch Error: #{fetch.error}")
      end

      clean
    end
  end

  def feed = resource

  def feed=(feed)
    self.resource = feed
  end

  private

  def load(data)
    Feed.transaction do
      feed.entries.update_all(in_latest_feed: false)
      feed.update!(data)
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
