feed = feeds.create :two,
  url: "http://another-feed.example.com",
  copyright: "Another Example",
  website_url: "http://another.example.com",
  title: "Another Example Feed",
  itunes_author: "Another Example Author"

entries.create_ordered :three, feed:,
  title: "Feed Two Episode one",
  content: "Second Feed Episode One",
  author: "Mr Another Feed",
  itunes_author: "Mr Another Feed",
  published_at: "2022-04-05 08:43:08",
  last_modified_at: "2022-04-05 08:43:08",
  guid: "3f6a8ee0-37f4-4fa0-844e-6c4d7e58f035",
  itunes_subtitle: "In another beginning",
  itunes_title: "Feed Two Episode one",
  itunes_summary: "The first episode of another feed"
