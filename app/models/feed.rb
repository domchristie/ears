class Feed < ApplicationRecord
  include Hashid::Rails
  include WebSubs
  include Importable

  has_many :entries, dependent: :destroy
  has_one :most_recent_entry, -> { order(published_at: :desc) }, class_name: "Entry"
  has_one :rss_image, as: :rss_imageable, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_one :following
  has_many :playlist_items, through: :entries

  scope :followed_by, ->(user) { where(id: user.followed_feeds) }

  validates :url, format: %r{http(s)?://.+}

  def empty?
    !last_checked_at
  end

  def sync(source)
    SyncFeedJob.perform_now(self, source:)
    reload
  end

  def last_modified
    [
      updated_at,
      most_recent_entry.published_at,
      most_recent_play_by(Current.user)&.updated_at
    ].compact.max
  end

  def author
    itunes_author || managing_editor
  end

  def image_url
    rss_image.try(:url) || itunes_image
  end

  def last_checked_at
    imports.order(finished_at: :desc).first&.finished_at
  end

  def import_source
    imports.order(finished_at: :desc).first&.source
  end

  def share_url
    "https://pod.link/#{Base64.urlsafe_encode64(url).delete("=")}"
  end

  def most_recent_play_by(user)
    plays.most_recent_by(user)
  end

  def followed_by?(user)
    followings.where(user: user).exists?
  end
end
