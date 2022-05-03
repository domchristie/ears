module PlaysHelper
  def play_remaining_in_words(remaining)
    if remaining > 0
      remaining = ActiveSupport::Duration.build(remaining.round)
      parts = remaining.parts
      [
        (parts[:hours].to_i > 1 && "#{parts[:hours]} hrs"),
        (parts[:hours].to_i == 1 && parts[:minutes].to_i < 1 && "#{parts[:hours]} hour"),
        (parts[:hours].to_i == 1 && parts[:minutes].to_i >= 1 && "#{parts[:hours]} hr"),
        (parts[:minutes].to_i > 1 && "#{parts[:minutes]} mins"),
        (parts[:minutes].to_i == 1 && "#{parts[:minutes]} min")
      ].select(&:itself).join(" ")
    end
  end
end
