Hashid::Rails.configure do |config|
  config.salt = Rails.application.credentials.hashid_salt!
end
