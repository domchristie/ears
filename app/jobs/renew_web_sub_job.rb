class RenewWebSubJob < ApplicationJob
  queue_as :default

  def perform(web_sub)
    new_web_sub = WebSub.create!(
      feed: web_sub.feed,
      hub_url: web_sub.hub_url
    )
    WebSub::Manager.start(new_web_sub)
  end
end
