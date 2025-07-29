user = users.create(email: "demo@example.com")
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
  user.followings.create_with(sourceable: user).find_or_create_by!(feed: feed)
  SyncFeedJob.perform_now(feed, source: :seeds)
end
