module EntriesHelper
  def entry_duration(duration, options = {})
    if duration && duration > 0
      duration = ActiveSupport::Duration.build(duration)
      parts = duration.parts
      human = "%02d:%02d:%02d" % [
        parts.fetch(:hours, 0),
        parts.fetch(:minutes, 0),
        parts.fetch(:seconds, 0)
      ]
      tag.time human, **options.merge(datetime: duration.iso8601)
    end
  end
end
