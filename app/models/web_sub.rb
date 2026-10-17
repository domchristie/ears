class WebSub < ApplicationRecord
  include Hashid::Rails

  class RequestFailed < StandardError; end

  belongs_to :feed, foreign_key: :feed_url, primary_key: :url

  RENEWAL_WINDOW = 3.hours
  VERIFICATION_TIMEOUT = 1.hour

  scope :not_expiring_soon, -> { where(expires_at: RENEWAL_WINDOW.from_now..) }

  scope :awaiting_verification, -> {
    where(expires_at: nil, created_at: VERIFICATION_TIMEOUT.ago..)
  }

  scope :renewal_not_due, -> { not_expiring_soon.or(awaiting_verification) }

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

    Fetch.start(request).tap do |response|
      unless response.is_a?(Net::HTTPSuccess)
        raise RequestFailed, "#{hub_url} responded #{response.code} for #{feed_url}"
      end
    end
  end

  def start_later
    StartWebSubJob.perform_later(self)
  end

  def confirm!(lease_seconds)
    update!(expires_at: created_at + lease_seconds)
    WebSub.where(feed_url:, hub_url:).where.not(id:).delete_all
  end

  def self.start_later!(...)
    create!(...).tap(&:start_later)
  end

  private

  def set_secret
    self.secret = SecureRandom.uuid
  end
end
