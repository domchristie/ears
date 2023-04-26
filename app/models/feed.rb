class Feed < ApplicationRecord
  include Hashid::Rails

  has_many :entries, dependent: :destroy
  has_one :most_recent_entry, -> { order(published_at: :desc) }, class_name: "Entry"
  has_one :rss_image, as: :rss_imageable
  has_many :web_subs, foreign_key: :feed_url, primary_key: :url, dependent: :destroy
  has_many :active_web_subs, -> { where("web_subs.expires_at > ?", Time.current) }, class_name: "WebSub", foreign_key: :feed_url, primary_key: :url
  has_many :plays, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_many :playlist_items, through: :entries
  has_many :fetches, foreign_key: :resource_id, dependent: :destroy

  scope :followed_by, ->(user) { where(id: user.followed_feeds) }
  scope :web_subable, -> { Feed.where.not(web_sub_hub_url: nil) }

  after_commit :start_web_sub, if: :saved_change_to_web_sub_hub_url?

  validates :url, format: %r{http(s)?://.+}

  def author
    itunes_author || managing_editor
  end

  def image_url
    rss_image.try(:url) || itunes_image
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

  def self.attributes_for_import(remote_feed)
    {
      web_sub_hub_url: remote_feed.hubs.first,
      copyright: remote_feed.copyright,
      description: remote_feed.description,
      language: remote_feed.language,
      last_build_at: remote_feed.last_built,
      website_url: remote_feed.url,
      managing_editor: remote_feed.managing_editor,
      title: remote_feed.title,
      ttl: remote_feed.ttl,
      itunes_author: remote_feed.itunes_author,
      itunes_block: remote_feed.itunes_block == "Yes",
      itunes_image: remote_feed.itunes_image,
      itunes_explicit: remote_feed.itunes_explicit == "true",
      itunes_complete: remote_feed.itunes_complete == "Yes",
      itunes_keywords: remote_feed.itunes_keywords,
      itunes_type: remote_feed.itunes_type,
      itunes_new_feed_url: remote_feed.itunes_new_feed_url,
      itunes_subtitle: remote_feed.itunes_subtitle,
      itunes_summary: remote_feed.itunes_summary
    }
  end

  def self.encode_url(url)
    "encoded_url#{Encryptor.url_safe_encrypt(url)}"
  end

  def self.decode_url(url)
    Encryptor.url_safe_decrypt(url[11..])
  end

  def start_web_sub
    StartWebSubJob.perform_later(self)
  end
end
