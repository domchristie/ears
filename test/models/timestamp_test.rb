require "test_helper"

class TimestampTest < ActiveSupport::TestCase
  test "m:ss" do
    timestamp = Timestamp.new("1:23")
    assert_equal 0, timestamp.hours
    assert_equal 1, timestamp.minutes
    assert_equal 23, timestamp.seconds
    assert_equal 83, timestamp.duration_in_seconds
  end

  test "mm:ss" do
    timestamp = Timestamp.new("12:34")
    assert_equal 0, timestamp.hours
    assert_equal 12, timestamp.minutes
    assert_equal 34, timestamp.seconds
    assert_equal 754, timestamp.duration_in_seconds
  end

  test "mmm:ss" do
    timestamp = Timestamp.new("123:45")
    assert_equal 0, timestamp.hours
    assert_equal 123, timestamp.minutes
    assert_equal 45, timestamp.seconds
    assert_equal 7425, timestamp.duration_in_seconds
  end

  test "h:mm:ss" do
    timestamp = Timestamp.new("1:23:45")
    assert_equal 1, timestamp.hours
    assert_equal 23, timestamp.minutes
    assert_equal 45, timestamp.seconds
    assert_equal 5025, timestamp.duration_in_seconds
  end

  test "hh:mm:ss" do
    timestamp = Timestamp.new("12:34:56")
    assert_equal 12, timestamp.hours
    assert_equal 34, timestamp.minutes
    assert_equal 56, timestamp.seconds
    assert_equal 45296, timestamp.duration_in_seconds
  end

  test "hhh:mm:ss" do
    timestamp = Timestamp.new("123:45:43")
    assert_equal 123, timestamp.hours
    assert_equal 45, timestamp.minutes
    assert_equal 43, timestamp.seconds
    assert_equal 445543, timestamp.duration_in_seconds
  end

  test "m.ss" do
    timestamp = Timestamp.new("1.23")
    assert_equal 0, timestamp.hours
    assert_equal 1, timestamp.minutes
    assert_equal 23, timestamp.seconds
  end

  test "hh.mm.ss" do
    timestamp = Timestamp.new("12.34.56")
    assert_equal 12, timestamp.hours
    assert_equal 34, timestamp.minutes
    assert_equal 56, timestamp.seconds
  end

  test "invalid seconds" do
    timestamp = Timestamp.new("02:99")
    assert_equal 0, timestamp.hours
    assert_equal 0, timestamp.minutes
    assert_equal 0, timestamp.seconds
  end

  test "invalid minutes" do
    timestamp = Timestamp.new("03:99:24")
    assert_equal 0, timestamp.hours
    assert_equal 0, timestamp.minutes
    assert_equal 0, timestamp.seconds
  end

  test "invalid format" do
    timestamp = Timestamp.new("12:34:56:54")
    assert_equal 0, timestamp.hours
    assert_equal 0, timestamp.minutes
    assert_equal 0, timestamp.seconds
    refute timestamp.valid?
  end

  test "#valid? with a valid format" do
    assert Timestamp.new("12:34").valid?
  end

  test "#valid? with an invalid format" do
    refute Timestamp.new("12:34:56:54").valid?
  end

  test "#to_s preserves the original source" do
    assert_equal "1.23", Timestamp.new("1.23").to_s
  end
end
