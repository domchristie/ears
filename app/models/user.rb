class User < ApplicationRecord
  has_many :followings, dependent: :destroy
  has_many :plays, dependent: :destroy
  has_many :followed_feeds, through: :followings, source: :feed
  has_many :played_feeds, through: :plays, source: :feed

  before_save :downcase_email

  validates(
    :email,
    format: {with: URI::MailTo::EMAIL_REGEXP},
    presence: true,
    uniqueness: true
  )

  private

  def downcase_email
    self.email = email.downcase
  end
end
