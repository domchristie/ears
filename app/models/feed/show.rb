class Feed::Show
  def initialize(params)
    @params = params
  end

  def start
    if !feed.last_checked_at
      SyncFeedJob.perform_now(feed, source: :feeds_show)
      feed.reload
    end
  end

  def entries
    @entries ||= feed
      .entries
      .order(published_at: :desc)
      .limit(52) # TODO pagination
  end

  def feed
    @feed ||= find_feed
  end

  private

  def find_feed
    [:id, :url].lazy.filter_map do |key|
      @params[key] && Feed.find_by(key => @params[key])
    end.first
  end
end
