require "application_system_test_case"

class FallbackPlayerTest < ApplicationSystemTestCase
  driven_by :rack_test

  test "fallback iframe player is present" do
    user = users(:one)
    sign_in_as user
    assert_selector "iframe[name='player']"
  end
end
