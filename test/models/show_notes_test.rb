require "test_helper"

class ShowNotesTest < ActiveSupport::TestCase
  test "links open in a new tab/window" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/<a href="http:\/\/example\.com" target="_blank" rel="external noopener">/, show_notes.to_s)
  end

  test "linkifies timestamps" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/<a data-action="player#skipToAndPlay" data-player-time-param="0" tabindex="0" href="http:\/\/example\.com\/one\.mp3\?t=0">/, show_notes.to_s)
  end

  test "timestamps in existing links are ignored" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/<a href="#" target="_blank" rel="external noopener">\(0:00\) already linked/, show_notes.to_s)
  end
end
