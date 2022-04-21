class StartWebSubJob < ApplicationJob
  queue_as :default

  def perform(feed)
    web_sub = Feed.web_subs.create!
    web_sub.start
  end
end
