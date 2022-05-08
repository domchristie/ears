class Entry < ApplicationRecord
  belongs_to :feed, touch: true
  has_many :plays, dependent: :destroy

  def duration
    itunes_duration
  end

  def summary
    itunes_summary || description
  end

  def image_url
    itunes_image_url || super || feed.image_url
  end

  def resume_enclosure_url(play)
    [enclosure_url, play.try(:elapsed)].compact.join("#t=")
  end

  def media_session_metadata
    {
      title: title,
      artist: feed.title,
      album: published_at.to_date.to_fs(:short),
      artwork: [{src: feed.image_url, sizes: "512x512"}]
    }
  end

  def most_recent_play_by(user)
    plays.most_recent_by(user)
  end

  def upcoming_play
    plays.build(elapsed: 0, remaining: duration)
  end

  def self.import_all!(feed_id, remote_entries)
    attributes = remote_entries.map do |remote_entry|
      Entry.attributes_for_import(remote_entry)&.merge(feed_id: feed_id)
    end.compact

    Entry.upsert_all(attributes, unique_by: :guid, record_timestamps: true)
  end

  def self.attributes_for_import(remote_entry)
    return unless remote_entry[:enclosure_url]

    {
      title: remote_entry.title,
      content: remote_entry.content,
      description: remote_entry.summary,
      url: remote_entry.url,
      author: remote_entry.author,
      published_at: remote_entry.published,
      last_modified_at: remote_entry.updated,
      guid: remote_entry.entry_id,
      image_url: (remote_entry.image unless remote_entry.image == remote_entry.enclosure_url),
      itunes_author: remote_entry.itunes_author,
      itunes_block: remote_entry.itunes_block == "Yes",
      itunes_duration: parse_duration(remote_entry.itunes_duration),
      itunes_explicit: remote_entry.itunes_explicit == "true",
      itunes_keywords: remote_entry.itunes_keywords,
      itunes_subtitle: remote_entry.itunes_subtitle,
      itunes_image_url: remote_entry.itunes_image,
      itunes_closed_captioned: remote_entry.itunes_closed_captioned,
      itunes_order: remote_entry.itunes_order,
      itunes_season: remote_entry.itunes_season,
      itunes_episode: remote_entry.itunes_episode,
      itunes_title: remote_entry.itunes_title,
      itunes_episode_type: remote_entry.itunes_episode_type,
      itunes_summary: remote_entry.itunes_summary,
      enclosure_length: remote_entry.enclosure_length,
      enclosure_type: remote_entry.enclosure_type,
      enclosure_url: remote_entry.enclosure_url
    }
  end

  def self.parse_duration(duration)
    if duration&.include?(":")
      duration
        .split(":")
        .map(&:to_i)
        .reverse
        .each_with_index.map { |n, i| i == 0 ? n : n * 60**i }
        .sum
    else
      duration
    end
  end
end
