class WebSub::Manager
  def self.start(web_sub)
    return if Rails.env.development?

    HTTParty.post(
      web_sub.hub_url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "hub.callback": web_sub.callback_url,
        "hub.mode": "subscribe",
        "hub.topic": web_sub.feed_url,
        "hub.secret": web_sub.secret
      }
    )
  end
end
