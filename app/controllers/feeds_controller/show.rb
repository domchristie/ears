class FeedsController::Show < ControllerAction
  def call
    if !feed.last_checked_at
      SyncFeedJob.perform_now(feed, source: :feeds_show)
      feed.reload
    end
  end

  def title
    feed.title
  end

  def image_url
    feed.image_url
  end

  def author
    feed.author
  end

  def episodes
    @episodes ||= EpisodeCollection.new(
      entries: feed.entries.includes(:feed).then { |entries|
        params[:query].present? ? entries.entry_search(params[:query]) : entries
      },
      user: current_user,
      limit: 25,
      order: {published_at: (feed.itunes_type == "serial") ? :asc : :desc}
    ).episodes
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

  def last_modified
    [
      feed.updated_at,
      most_recent_entry.published_at,
      most_recent_play&.updated_at
    ].compact.max
  end

  private

  def find_feed
    if params[:id]
      Feed.find_by_hashid!(params[:id])
    elsif params[:encoded_url]
      url = Feed.decode_url(params[:encoded_url])
      Feed.find_or_create_by(url: url)
    end
  end

  def most_recent_entry
    @most_recent_entry ||= feed.most_recent_entry
  end

  def most_recent_play
    @most_recent_play ||= feed.most_recent_play_by(current_user)
  end

  def replay_resume_action
    {
      partial: "plays/featured",
      locals: {
        title: most_recent_play.complete? ? "Replay" : "Resume",
        play: most_recent_play,
        highlight: params[:source] == "recently_played"
      }
    }
  end

  def latest_action
    {
      partial: "plays/featured",
      locals: {
        title: "Latest",
        play: most_recent_entry.upcoming_play_by(current_user),
        highlight: params[:source] == "recently_updated"
      }
    }
  end
end
