class Feed < ApplicationRecord
  include Hashid::Rails
  include Importable

  has_many :entries, dependent: :destroy
  has_one :most_recent_entry, -> { order(published_at: :desc) }, class_name: "Entry"
  has_one :rss_image, as: :rss_imageable, dependent: :destroy
  has_many :web_subs, foreign_key: :feed_url, primary_key: :url, dependent: :destroy
  has_many :active_web_subs, -> { where("web_subs.expires_at > ?", Time.current) }, class_name: "WebSub", foreign_key: :feed_url, primary_key: :url
  has_many :plays, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_one :following
  has_many :playlist_items, through: :entries

  scope :followed_by, ->(user) { where(id: user.followed_feeds) }
  scope :web_subable, -> { Feed.where.not(web_sub_hub_url: nil) }

  before_save if: :will_save_change_to_url? do
    WebSub.where(feed_url: url_in_database).destroy_all
  end
  after_commit :start_web_sub, if: :web_sub_attributes_changed?

  validates :url, format: %r{http(s)?://.+}

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

  def self.encode_url(url)
    "encoded_url#{Encryptor.url_safe_encrypt(url)}"
  end

  def self.decode_url(url)
    Encryptor.url_safe_decrypt(url[11..])
  end

  def web_subable?
    web_sub_hub_url.present?
  end

  def web_sub_attributes_changed?
    saved_change_to_web_sub_hub_url? || saved_change_to_url?
  end

  def start_web_sub
    StartWebSubJob.perform_later(self)
  end
end
