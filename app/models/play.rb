class Play < ApplicationRecord
  belongs_to :entry
  belongs_to :feed
  belongs_to :user

  scope :by, ->(user) { where(user: user) }

  def self.most_recent_by(user)
    by(user).order(updated_at: :desc).first
  end

  def progress
    1 / (elapsed + remaining) * elapsed
  end

  def complete?
    remaining <= 60
  end
end
