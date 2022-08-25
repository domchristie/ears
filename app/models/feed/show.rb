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
    if @params[:id]
      Feed.find(@params[:id])
    elsif @params[:encoded_url]
      url = Feed.decode_url(@params[:encoded_url])
      Feed.find_or_create_by(url: url)
    end
  end
end
