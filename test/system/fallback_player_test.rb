require "application_system_test_case"

class FallbackPlayerTest < ApplicationSystemTestCase
  driven_by :rack_test

  test "fallback iframe player is present" do
    user = sign_in_as users.one
    assert_selector "iframe[name='player']"
    assert_no_selector "[data-player-target='controls']"
  end
end
