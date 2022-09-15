module PlaysHelper
  def chrono_duration(duration)
    parts = ActiveSupport::Duration.build(duration.to_i).parts
    [
      parts[:hours].to_i > 0 ? parts[:hours].to_s.rjust(2, "0") : nil,
      parts[:minutes].to_s.rjust(2, "0"),
      parts[:seconds].to_s.rjust(2, "0")
    ].compact.join(":")
  end

  def iso8601_duration(duration)
    ActiveSupport::Duration.build(duration.to_i).iso8601
  end

  def play_remaining_in_words(remaining)
    remaining = ActiveSupport::Duration.build(remaining.round)
    remaining.parts.with_defaults(hours: nil, minutes: nil) => {hours:, minutes:}
    [
      (hours.to_i > 1 && "#{hours} hrs"),
      (hours.to_i == 1 && minutes.to_i < 1 && "#{hours} hour"),
      (hours.to_i == 1 && minutes.to_i >= 1 && "#{hours} hr"),
      (minutes.to_i > 1 && "#{minutes} mins"),
      (minutes.to_i == 1 && "#{minutes} min"),
      (hours.to_i == 0 && minutes.to_i < 1 && "< 1 min")
    ].select(&:itself).join(" ")
  end

  def play_state_class_names(play)
    class_names(
      "--started": play.started?,
      "--played": play.complete?
    )
  end
end
