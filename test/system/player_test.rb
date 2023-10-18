require "application_system_test_case"

class PlayerTest < ApplicationSystemTestCase
  test "fallback iframe player is removed" do
    user = users(:one)
    sign_in_as user
    assert_no_selector "iframe[name='player']"
    assert_selector "[data-player-target='controls']"
  end

  test "player controller is initialized after sign in" do
    user = users(:one)
    visit root_path
    assert_no_selector "[data-controller~='player']"
    sign_in_as user
    assert_selector "[data-controller~='player']"
  end
end
