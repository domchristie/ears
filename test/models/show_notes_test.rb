require "test_helper"

class ShowNotesTest < ActiveSupport::TestCase
  test "removing blank p elements" do
    show_notes = ShowNotes.new(entries(:one))
    assert_no_match(/<p> <\/p>/, show_notes.to_s)
  end

  test "links open in a new tab/window" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/<a href="http:\/\/example\.com" target="_blank" rel="external noopener">/, show_notes.to_s)
  end

  test "linkifies timestamps including a link to load the player" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(%r{
      <span>\
        <a\ data-action="player#skipToAndPlay"\ data-player-time-param="0"\ tabindex="0"\ href="http:\/\/example\.com\/one\.mp3\#t=0">0:00</a>\
        <a\ data-turbo-frame="player"\ data-player-target="loader"\ hidden="hidden"\ class="hidden"\ href="/entries/#{entries(:one).hashid}/player?autoplay=true">
    }x, show_notes.to_s)
  end

  test "timestamps in existing links are ignored" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/<a href="#" target="_blank" rel="external noopener">\(0:00\) already linked/, show_notes.to_s)
  end

  test "formatting plain text" do
    entry = entries(:one)
    entry.update!(content: "Plain text")
    show_notes = ShowNotes.new(entry)
    assert_match(/<p>Plain text<\/p>/, show_notes.to_s)
  end

  test "linking unlinked URLs" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/Find out more on <a href="http:\/\/example.com" target="_blank" rel="external noopener">http:\/\/example.com/, show_notes.to_s)
  end

  test "linking email addresses" do
    show_notes = ShowNotes.new(entries(:one))
    assert_match(/email <a href="mailto:email@example.com" target="_blank" rel="external noopener">email@example.com/, show_notes.to_s)
  end

  test "sanitization" do
    entry = entries(:one)
    entry.update!(content: "This & that")
    show_notes = ShowNotes.new(entry)
    assert_match(/This &amp; that/, show_notes.to_s)
  end
end
