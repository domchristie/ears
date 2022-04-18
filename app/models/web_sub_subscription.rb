class WebSubSubscription < ApplicationRecord
  include Hashid::Rails
  hashid_config salt: Rails.application.credentials.web_sub_hashid_salt!

  belongs_to :feed
end
