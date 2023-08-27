module EpisodeListable
  extend ActiveSupport::Concern

  DEFAULT_LIMIT = 25
  DEFAULT_MORE_FEEDS_LIMIT = 5

  def call(limit: DEFAULT_LIMIT)
    @limit = limit
  end

  def episodes
    []
  end

  def present?
    episodes.present?
  end
end
