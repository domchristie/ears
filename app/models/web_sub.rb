class WebSub < ApplicationRecord
  include Hashid::Rails

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

  def hub_uri
    URI(hub_url)
  end

  def self.start(web_sub)
    return if Rails.env.development?

    request = Net::HTTP::Post.new(web_sub.hub_uri,
      "Content-Type" => "application/x-www-form-urlencoded"
    )
    request.body = URI.encode_www_form(
      "hub.callback" => web_sub.callback_url,
      "hub.mode"     => "subscribe",
      "hub.topic"    => web_sub.feed_url,
      "hub.secret"   => web_sub.secret
    )

    Http.start request
  end

  private

  def set_secret
    self.secret = SecureRandom.uuid
  end
end
