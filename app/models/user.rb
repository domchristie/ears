class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes

  has_secure_password

  has_many :active_sessions, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :followed_feeds, through: :followings, source: :feed
  has_many :played_feeds, through: :plays, source: :feed

  before_validation do
    self.email = email.try(:downcase).try(:strip)
  end

  validates(
    :email,
    format: {with: URI::MailTo::EMAIL_REGEXP},
    presence: true,
    uniqueness: true
  )

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end
end
