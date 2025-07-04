class Entry::Import::Transform < Import::Transform
  def data
    return {} unless @source[:enclosure_url]

    @data ||= {
      title: @source.title,
      content: @source.content,
      description: @source.summary,
      url: @source.url,
      author: @source.author,
      published_at: @source.published,
      last_modified_at: @source.updated,
      guid: @source.entry_id,
      image_url: (@source.image unless @source.image == @source.enclosure_url),
      enclosure_length: @source.enclosure_length,
      enclosure_type: @source.enclosure_type,
      enclosure_url: @source.enclosure_url,

      itunes_author: @source.itunes_author,
      itunes_block: @source.itunes_block&.downcase == "yes",
      itunes_duration: parse_duration(@source.itunes_duration),
      itunes_explicit: @source.itunes_explicit&.downcase == "true",
      itunes_keywords: @source.itunes_keywords,
      itunes_subtitle: @source.itunes_subtitle,
      itunes_image_url: @source.itunes_image,
      itunes_closed_captioned: @source.itunes_closed_captioned,
      itunes_order: @source.itunes_order,
      itunes_season: @source.itunes_season,
      itunes_episode: @source.itunes_episode,
      itunes_title: @source.itunes_title,
      itunes_episode_type: @source.itunes_episode_type,
      itunes_summary: @source.itunes_summary,

      podcast_chapters_url: @source.podcast_chapters_url,
      podcast_chapters_type: @source.podcast_chapters_type
    }
  end

  private

  def parse_duration(duration)
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
