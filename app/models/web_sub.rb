class WebSub < ApplicationRecord
  include Hashid::Rails
  hashid_config salt: Rails.application.credentials.web_sub_hashid_salt!

  belongs_to :feed, foreign_key: :feed_url, primary_key: :url

  before_create :set_secret

  def verify_topic(topic)
    topic == feed.url
  end

  def validate_signature(algorithm, signature)
    algorithms = {
      sha1: Digest::SHA1,
      sha256: Digest::SHA256,
      sha384: Digest::SHA384,
      sha512: Digest::SHA512
    }
    signature == algorithms[algorithm.to_sym].hexdigest(secret)
  end

  def callback_url
    Rails.application.routes.url_helpers.web_sub_feed_url(self)
  end

  private

  def set_secret
    self.secret = SecureRandom.uuid
  end
end
