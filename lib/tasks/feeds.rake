namespace :feeds do
  namespace :sync do
    task all: :environment do
      Feed.all.each do |feed|
        SyncFeedJob.perform_now(feed, source: :rake)
      end
    end
  end

  task sync: :environment do
    Feed.where.missing(:active_web_subs).each do |feed|
      SyncFeedJob.perform_now(feed, source: :rake)
    end
  end
end
