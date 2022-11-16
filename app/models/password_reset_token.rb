class PasswordResetToken < ApplicationRecord
  belongs_to :user

  VALIDITY_DURATION = 20.minutes
end
