class NilEntry < Entry
  include Nil

  def feed
    NilFeed.new
  end

  def duration
    0
  end

  def media_session_metadata
    {}
  end
end
