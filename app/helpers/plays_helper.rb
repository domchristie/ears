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
    parts = remaining.parts
    [
      (parts[:hours].to_i > 1 && "#{parts[:hours]} hrs"),
      (parts[:hours].to_i == 1 && parts[:minutes].to_i < 1 && "#{parts[:hours]} hour"),
      (parts[:hours].to_i == 1 && parts[:minutes].to_i >= 1 && "#{parts[:hours]} hr"),
      (parts[:minutes].to_i > 1 && "#{parts[:minutes]} mins"),
      (parts[:minutes].to_i == 1 && "#{parts[:minutes]} min"),
      (parts[:minutes].to_i < 1 && "< 1 min")
    ].select(&:itself).join(" ")
  end

  def play_state_class_names(play)
    class_names(
      "--started": play.started?,
      "--played": play.complete?
    )
  end
end
