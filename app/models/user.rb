class User < ApplicationRecord
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
