class Timestamp
  REGEX = %r{
    (?:
      (?<=^|[^:.0-9])
      (?<hours>\d{1,3})[:.]
      (?<minutes>[0-5]\d)[:.]
      (?<seconds>[0-5]\d)
      (?=$|[^:.0-9])
    )|
    (?:
      (?<=^|[^:.0-9])
      (?<minutes>\d{1,3})[:.]
      (?<seconds>[0-5]\d)
      (?=$|[^:.0-9])
    )
  }x

  def initialize(source)
    @source = source
  end

  def hours
    parts[:hours].to_i
  end

  def minutes
    parts[:minutes].to_i
  end

  def seconds
    parts[:seconds].to_i
  end

  def duration_in_seconds
    (hours * 60 * 60) + (minutes * 60) + seconds.to_i
  end

  def valid?
    parts.present?
  end

  def to_s
    @source
  end

  private

  def parts
    return @parts if @parts
    @parts ||= @source.match(REGEX) || {}
  end
end
