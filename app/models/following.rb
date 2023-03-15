class Following < ApplicationRecord
  belongs_to :feed
  belongs_to :user
  belongs_to :sourceable, polymorphic: true
  accepts_nested_attributes_for :feed, reject_if: :feed_exists?

  private

  def feed_exists?(feed_attrs)
    Feed.find_by(url: feed_attrs["url"])
  end
end
