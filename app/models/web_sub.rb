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

  def start
    return if Rails.env.development?

    request = Net::HTTP::Post.new(hub_uri,
      "Content-Type" => "application/x-www-form-urlencoded"
    )
    request.body = URI.encode_www_form(
      "hub.callback" => callback_url,
      "hub.mode"     => "subscribe",
      "hub.topic"    => feed_url,
      "hub.secret"   => secret
    )

    Http::Navigation.start request
  end

  def confirm!(lease_seconds)
    update!(expires_at: created_at + lease_seconds)
    WebSub.where(feed_url:, hub_url:).where.not(id:).delete_all
  end

  def renew!
    WebSub.create!(feed:, hub_url:).start
  end

  def self.start!(...)
    create!(...).start
  end

  private

  def set_secret
    self.secret = SecureRandom.uuid
  end
end
