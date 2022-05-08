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

  task demo: :environment do
    user = User.find_or_create_by!(email: "demo@example.com")
    user.followings.destroy_all
    user.plays.destroy_all

    feed_urls = [
      "https://feeds.simplecast.com/BqbsxVfO", # 99pi
      "http://rss.acast.com/akimbo",
      "https://feeds.megaphone.fm/tamc1411507018", # football cliches
      "https://feeds.megaphone.fm/mysteryshow",
      "http://feeds.wnyc.org/radiolab",
      "https://feeds.megaphone.fm/replyall",
      "https://feeds.simplecast.com/xl36XBC2", # serial
      "http://feed.songexploder.net/songexploder",
      "http://feed.thisamericanlife.org/talpodcast",
      "https://feeds.npr.org/510318/podcast.xml", # up first
    ]
    feed_urls.each do |url|
      feed = Feed.find_or_create_by!(url: url)
      user.followings.find_or_create_by!(feed: feed)
      SyncFeedJob.perform_now(feed, source: :rake)
    end
  end
end
