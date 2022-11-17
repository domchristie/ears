class EpisodeCollection
  attr_reader :user, :query

  def initialize(entries:, user:, query: nil)
    @entries = entries
    @user = user
    @query = query.presence
  end

  def episodes(order: {published_at: :desc}, limit: nil)
    entries = query.present? ? self.entries.entry_search(query) : self.entries
    entries.order(order)
      .yield_self { |entries| limit ? entries.limit(limit) : entries }
      .map { |entry| build_episode(entry) }
  end

  private

  def build_episode(entry)
    Episode.new(entry:, user:, play: entry.recent_play)
  end

  def entries
    @entries
      .includes(:recent_play)
      .where("plays.user_id = ? OR plays.user_id IS NULL", user.id)
      .references(:plays)
  end
end
