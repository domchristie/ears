lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
loader.defaults language: "en-us", ttl: 600, managing_editor: "Example Author", description: lorem,
  author: "Mr Feed",
  itunes_author: "Mr Feed",
  itunes_summary: lorem,
  itunes_block: false,
  itunes_explicit: false,
  itunes_complete: false,
  itunes_type: "episodic",
  itunes_duration: 60,
  itunes_keywords: :crime,
  itunes_closed_captioned: false,
  itunes_order: 1,
  itunes_season: 1,
  itunes_episode: 1,
  itunes_episode_type: "MyString",
  enclosure_length: 60,
  enclosure_type: "audio/mp3"

def entries.create_ordered(label, feed:, **)
  sequence_id = feed.entries.count.succ

  create(label, feed:,
    title: "Episode #{label}",
    itunes_title: "Episode #{label}",
    content: "The #{sequence_id.ordinalize} episode",
    itunes_summary: "The #{sequence_id.ordinalize} episode",
    itunes_order: sequence_id,
    itunes_episode: sequence_id,
    url: "#{feed.website_url}/#{label}",
    itunes_image_url: "#{feed.website_url}/#{label}.jpg",
    enclosure_url: "#{feed.website_url}/#{label}.mp3",
    **
  )
end
def entries.create(label = nil, unique_by: [:feed, :itunes_episode], **) = super

register OpmlImport
