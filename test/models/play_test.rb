require "test_helper"

class PlayTest < ActiveSupport::TestCase
  test "#progress tracks the progress from 0 to 1" do
    assert_equal 0.25, Play.new(elapsed: 25, remaining: 75).progress
  end

  test "#complete? is false for short durations that have more than a 5% left" do
    refute Play.new(elapsed: 25, remaining: 75).complete?
  end

  test "#complete? is true for short durations that have less than a 5% left" do
    assert Play.new(elapsed: 96, remaining: 4).complete?
  end

  test "#complete? is false for long durations that have more than a minute left" do
    refute Play.new(elapsed: 3500, remaining: 100).complete?
  end

  test "#complete? is true for long durations that have less than a minute left" do
    assert Play.new(elapsed: 3560, remaining: 40).complete?
  end
end
