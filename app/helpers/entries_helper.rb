module EntriesHelper
  def entry_enclosure_at_time_url(entry, time = nil)
    uri = URI(entry.enclosure_url)
    params = URI.decode_www_form(uri.query || "")
    if time
      params += ["t", time]
      uri.fragment = "t=#{time}"
    end
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def entry_player_at_time_path(entry, time = nil)
    entry_player_path entry, t: time, anchor: ("t=#{time}" if time)
  end
end
