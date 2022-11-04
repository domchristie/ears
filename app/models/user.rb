class User < ApplicationRecord
  include Hashid::Rails
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = "no-reply@example.com"
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes

  has_secure_password

  attr_accessor :current_password

  has_many :active_sessions, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :followed_feeds, through: :followings, source: :feed
  has_many :played_feeds, through: :plays, source: :feed

  before_save :format_email, :format_unconfirmed_email

  validates(
    :email,
    format: {with: URI::MailTo::EMAIL_REGEXP},
    presence: true,
    uniqueness: true
  )

  validates(
    :unconfirmed_email,
    format: {with: URI::MailTo::EMAIL_REGEXP},
    allow_blank: true
  )

  def confirm!
    if unconfirmed_or_reconfirming?
      if unconfirmed_email.present?
        return false unless update(email: unconfirmed_email, unconfirmed_email: nil)
      end
      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def reconfirming?
    unconfirmed_email.present?
  end

  def unconfirmed_or_reconfirming?
    unconfirmed? || reconfirming?
  end

  def confirmable_email
    if unconfirmed_email.present?
      unconfirmed_email
    else
      email
    end
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  def self.authenticate_by(attributes)
    passwords, identifiers = attributes.to_h.partition do |name, value|
      !has_attribute?(name) && has_attribute?("#{name}_digest")
    end.map(&:to_h)

    raise ArgumentError, "One or more password arguments are required" if passwords.empty?
    raise ArgumentError, "One or more finder arguments are required" if identifiers.empty?
    if (record = find_by(identifiers))
      record if passwords.count { |name, value| record.public_send(:"authenticate_#{name}", value) } == passwords.size
    else
      new(passwords)
      nil
    end
  end

  private

  def format_email
    self.email = email.try(:downcase).try(:strip)
  end

  def format_unconfirmed_email
    if unconfirmed_email.present?
      self.unconfirmed_email = unconfirmed_email.try(:downcase).try(:strip)
    end
  end
end
