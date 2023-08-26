class User < ApplicationRecord
  include Hashid::Rails

  has_secure_password

  has_many :email_verification_tokens, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :followed_feeds, through: :followings, source: :feed
  has_many :played_feeds, through: :plays, source: :feed
  has_many :followed_entries, through: :followed_feeds, source: :entries
  has_many :played_entries, through: :plays, source: :entry
  has_one :queue, -> { where(name: "Queue") }, class_name: "Playlist"
  has_many :queued_entries, through: :queue, source: :entries
  has_many :queued_feeds, through: :queued_entries, source: :feed
  has_many :playlists, dependent: :destroy
  has_many :playlisted_items, through: :playlists, source: :items
  has_many :playlisted_feeds, through: :playlists, source: :feeds

  validates(
    :email,
    format: {with: URI::MailTo::EMAIL_REGEXP},
    presence: true,
    uniqueness: true
  )

  validates(
    :password,
    allow_nil: true,
    length: {minimum: 12},
    format: {with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])/}
  )

  before_validation do
    self.email = email&.downcase&.strip
  end

  before_validation if: :email_changed? do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).destroy_all
  end

  def queue
    super || create_queue!
  end
end
