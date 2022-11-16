class EmailVerificationToken < ApplicationRecord
  belongs_to :user

  VALIDITY_DURATION = 2.days
end
