class Episode
  include ActiveModel::API

  attr_accessor :entry, :user
  attr_writer :play

  delegate_missing_to :entry

  def play
    @play ||= Play.new(
      entry:, user:,
      elapsed: 0,
      remaining: entry.duration
    )
  end
end
