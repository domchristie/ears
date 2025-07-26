feed = resource = feeds.create :one,
  url: "http://feeds.example.com",
  copyright: "Example",
  website_url: "http://example.com",
  title: "Example Feed",
  itunes_author: "Example Author"

extractions.create :success, resource:, status: :success, result: { body: "test" }
extractions.create :not_modified, resource:, status: :not_modified
extractions.create :error, resource:, status: :error

import = imports.create :one, type: "Feed::Import", resource:, source: "web_sub"
import_extractions.create import:, extraction: extractions.success

entries.create_ordered :one, feed:,
  content: '<p>The first episode. Hosted on <a href="http://example.com">example.com</a>.</p><p>(0:00) In the beginning …</p><a href="#">(0:00) already linked</a><a href="#t=00:10">00:10 Fragment Link</a><p> </p><p>Find out more on http://example.com or email email@example.com</p>',
  published_at: "2022-04-05 08:43:08",
  last_modified_at: "2022-04-05 08:43:08",
  guid: "c638b3a8-eac8-4c13-9240-dcb2507b8be5",
  itunes_subtitle: "In the beginning"

entries.create_ordered :two, feed:,
  published_at: "2022-04-12 08:43:08",
  last_modified_at: "2022-04-12 08:43:08",
  guid: "e6a21828-e7af-445e-8166-076d397900bd",
  itunes_subtitle: "There was"

web_subs.create :one,
  feed_url: "http://feeds.example.com",
  hub_url: "https://pubsubhubbub.appspot.com/",
  secret: "9057f028-6696-4134-8d9e-913d1e6cee44"

rss_images.create rss_imageable: feed,
  url: "MyString",
  description: "MyText",
  title: "MyString",
  width: 1,
  height: 1,
  website_url: "MyString"
