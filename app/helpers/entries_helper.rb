module EntriesHelper
  def entry_enclosure_at_time_url(entry, time = nil)
    uri = URI(entry.enclosure_url)
    uri.fragment = "t=#{time}" if time
    uri.to_s
  end

  def entry_player_at_time_path(entry, time = nil)
    entry_player_path entry, t: time, anchor: ("t=#{time}" if time)
  end
end
