class PublishingSchedule
  def initialize(items)
    @items = items.order(:published_at)
  end

  def timestamps
    @timestamps ||= @items.pluck(:published_at)
  end

  def dormant?
    timestamps.last < 90.days.ago
  end

  def preferred_weekdays
  end

  def by_calendar_week
    timestamps.group_by do |timestamp|
      timestamp.to_date.cweek
    end.transform_values do |timestamp|
      timestamp.map(&:wday).uniq.sort
    end
  end

  def most_common_weekly_schedule
    schedules = by_calendar_week.values
    grouped = schedules.tally
    (grouped.max_by { |_, count| count }).first || []
  end

  def most_common_weekly_schedule_probability
    schedules = by_calendar_week.values
    grouped = schedules.tally
    (grouped.max_by { |_, count| count } || []).last.to_f / schedules.size
  end
end
