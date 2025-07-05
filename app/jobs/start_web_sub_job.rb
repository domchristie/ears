class StartWebSubJob < ApplicationJob
  queue_as :default

  def perform(feed)
    feed.web_subs.start!(hub_url: feed.web_sub_hub_url)
  end
end
