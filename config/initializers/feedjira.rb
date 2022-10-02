class Feedjira::Parser::ITunesRSS
  elements :link, as: :hubs, value: :href, with: {rel: "hub"}
  elements :"atom:link", as: :hubs, value: :href, with: {rel: "hub"}
end

class Feedjira::Parser::ITunesRSSItem
  element :"podcast:chapters", value: :url, as: :podcast_chapters_url
  element :"podcast:chapters", value: :type, as: :podcast_chapters_type
end
