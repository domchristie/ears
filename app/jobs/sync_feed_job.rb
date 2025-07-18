class SyncFeedJob < ApplicationJob
  queue_as :default

  def perform(feed, source:, conditional: true)
    Feed::Import.start feed:, source:, conditional:
  end
end
