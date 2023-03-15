class PlaylistItem < ApplicationRecord
  include Hashid::Rails
  belongs_to :playlist
  belongs_to :entry
  has_one :user, through: :playlist
  has_one :feed, through: :entry
  has_many :followings, as: :sourceable

  after_create :follow_feed!, unless: -> {
    Following.where(user:, feed:).exists?
  }

  private

  def follow_feed!
    Following.create!(user:, feed:, sourceable: self)
  end
end
