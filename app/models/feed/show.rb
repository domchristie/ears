class Feed::Show
  delegate_missing_to :feed

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

  def actions
    [
      (replay_resume_action if most_recent_play.present?),
      (latest_action if most_recent_play&.entry != most_recent_entry)
    ].compact
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

  def most_recent_play
    @most_recent_play ||= feed.most_recent_play_by(Current.user)
  end

  def most_recent_entry
    @most_recent_entry ||= feed.most_recent_entry
  end

  def replay_resume_action
    {
      partial: "plays/featured",
      locals: {
        title: most_recent_play.complete? ? "Replay" : "Resume",
        play: most_recent_play,
        highlight: @params[:source] == "recently_played"
      }
    }
  end

  def latest_action
    {
      partial: "plays/featured",
      locals: {
        title: "Latest",
        play: most_recent_entry.upcoming_play_by(Current.user),
        highlight: @params[:source] == "recently_updated"
      }
    }
  end
end
