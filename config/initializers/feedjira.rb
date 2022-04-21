class Feedjira::Parser::ITunesRSS
  elements :link, as: :hubs, value: :href, with: {rel: "hub"}
  elements :"atom:link", as: :hubs, value: :href, with: {rel: "hub"}
end
