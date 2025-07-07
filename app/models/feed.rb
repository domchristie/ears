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

  saves_nested_attributes_for :entries, with: -> {
    Entry.upsert_all(
      entries_attributes,
      unique_by: [:feed_id, :formatted_guid],
      record_timestamps: true
    )
  }

  saves_nested_attributes_for :rss_image, with: -> {
    RssImage.upsert(
      rss_image_attributes,
      unique_by: [:rss_imageable_type, :rss_imageable_id],
      record_timestamps: true
    )
  }

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

  def following_for(user)
    user.followings.find_or_initialize_by(feed: self)
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

  def self.parse(rss)
    Feedjira.parse(rss, parser: Feedjira::Parser::ITunesRSS)
  end
end
