require "test_helper"

class EntryTimestampTest < ActiveSupport::TestCase
  test "#valid? with a timestamp within the entry duration" do
    entry = entries(:one)
    timestamp = Timestamp.new("0:30")
    assert EntryTimestamp.new(entry:, timestamp:).valid?
  end

  test "#valid? with a timestamp outwith the entry duration" do
    entry = entries(:one)
    timestamp = Timestamp.new("12:34:56")
    refute EntryTimestamp.new(entry:, timestamp:).valid?
  end
end
