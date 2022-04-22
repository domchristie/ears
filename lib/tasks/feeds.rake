namespace :feeds do
  task sync: :environment do
    Feed.all.each do |feed|
      SyncFeedJob.perform_now(feed, source: :rake)
    end
  end
end
