require "application_system_test_case"

class QueueTest < ApplicationSystemTestCase
  test "enqueueing an entry" do
    user = users(:one)
    sign_in_as user
    assert_selector "#play_later", text: "Play later episodes appear here"

    within("#episodes") { click_button "Play Later", match: :first }
    assert_text "ADDED"
    assert_selector "#play_later article p", text: "Example Feed"
  end
end
