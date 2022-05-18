class WebSub < ApplicationRecord
  include Hashid::Rails
  hashid_config salt: Rails.application.credentials.web_sub_hashid_salt!

  belongs_to :feed, foreign_key: :feed_url, primary_key: :url

  scope :expiring, -> { where(expires_at: Time.current..3.hours.from_now) }

  scope :expired, -> {
    where.not(expires_at: nil).where("expires_at < ?", Time.current)
  }

  before_create :set_secret

  def verify_topic(topic)
    topic == feed.url
  end

  def validate_signature(algorithm, signature, payload)
    digest = OpenSSL::Digest.new(algorithm.to_s)
    signature == OpenSSL::HMAC.hexdigest(digest, secret, payload)
  end

  def callback_url
    Rails.application.routes.url_helpers.web_sub_feed_url(self)
  end

  private

  def set_secret
    self.secret = SecureRandom.uuid
  end
end
