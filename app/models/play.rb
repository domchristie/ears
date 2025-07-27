class Play < ApplicationRecord
  include Hashid::Rails

  belongs_to :entry
  belongs_to :feed, default: -> { entry.feed }
  belongs_to :user
  has_many :followings, as: :sourceable

  scope :by, ->(user) { where(user: user) }

  after_create :follow_feed!

  def self.most_recent_by(user)
    by(user).order(updated_at: :desc).first
  end

  def duration
    remaining ? elapsed + remaining : entry.duration
  end

  def progress
    duration == 0 || duration.nil? ? 0 : elapsed / duration
  end

  def complete?
    duration.present? &&
      (0.05 * duration > 60 ? remaining < 60 : progress > 0.95)
  end

  def started?
    persisted?
  end

  def resume_timestamp
    complete? || elapsed.to_i == 0 ? nil : elapsed
  end

  private

  def follow_feed!
    feed.followings.create_with(sourceable: self).find_or_create_by!(user:)
  end
end
