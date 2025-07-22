class Feedjira::Parser::ITunesRSS
  elements :link, as: :hubs, value: :href, with: {rel: "hub"}
  elements :"atom:link", as: :hubs, value: :href, with: {rel: "hub"}
  element :"podcast:guid", as: :podcast_guid
  element :"podcast:funding", as: :podcast_funding_text
  element :"podcast:funding", value: :url, as: :podcast_funding_url
end

class Feedjira::Parser::ITunesRSSItem
  element :"podcast:chapters", value: :url, as: :podcast_chapters_url
  element :"podcast:chapters", value: :type, as: :podcast_chapters_type
  element :"podcast:funding", as: :podcast_funding_text
  element :"podcast:funding", value: :url, as: :podcast_funding_url
  elements :"podcast:transcript", value: :url, as: :podcast_transcript_urls
  elements :"podcast:transcript", value: :type, as: :podcast_transcript_types
  elements :"podcast:transcript", value: :language, as: :podcast_transcript_languages
  elements :"podcast:transcript", value: :rel, as: :podcast_transcript_rels
end
