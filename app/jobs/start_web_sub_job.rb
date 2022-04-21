class StartWebSubJob < ApplicationJob
  queue_as :default

  def perform(feed)
    web_sub = feed.web_subs.create!(hub_url: feed.web_sub_hub_url)
    WebSub::Manager.start(web_sub)
  end
end
