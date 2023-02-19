class EntryTimestamp
  attr_reader :entry, :timestamp

  def initialize(entry:, timestamp:)
    @entry = entry
    @timestamp = timestamp
  end

  def url
    return @uri if @uri

    uri = URI(entry.enclosure_url)
    uri.fragment = "t=#{duration_in_seconds}"
    @uri = uri.to_s
  end

  def duration_in_seconds
    timestamp.duration_in_seconds
  end

  def valid?
    (0..entry.duration.to_i).cover? duration_in_seconds
  end

  def to_partial_path
    "entry_timestamps/entry_timestamp"
  end

  def to_s
    timestamp.to_s
  end
end
