class Play < ApplicationRecord
  belongs_to :entry
  belongs_to :feed

  def self.most_recent
    order(updated_at: :desc).first
  end
end
