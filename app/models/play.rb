class Play < ApplicationRecord
  include Hashid::Rails

  belongs_to :entry
  belongs_to :feed
  belongs_to :user

  scope :by, ->(user) { where(user: user) }

  def self.most_recent_by(user)
    by(user).order(updated_at: :desc).first
  end

  def duration
    remaining ? elapsed + remaining : entry.duration
  end

  def progress
    duration == 0 ? 0 : elapsed / duration
  end

  def complete?
    0.05 * duration > 60 ? remaining < 60 : progress > 0.95
  end

  def started?
    persisted?
  end
end
