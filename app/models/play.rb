class Play < ApplicationRecord
  belongs_to :entry
  belongs_to :feed

  def self.most_recent
    order(updated_at: :desc).first
  end

  def progress
    1 / (elapsed + remaining) * elapsed
  end

  def complete?
    remaining <= 60
  end
end
