require "application_system_test_case"

class PlayerTest < ApplicationSystemTestCase
  test "fallback iframe player is removed" do
    user = users(:one)
    sign_in_as user
    assert_no_selector "iframe[name='player']"
    assert_selector "[data-player-target='controls']"
  end
end
