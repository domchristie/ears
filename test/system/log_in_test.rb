require "application_system_test_case"

class LogInTest < ApplicationSystemTestCase
  test "logging in" do
    user = users(:one)
    visit login_path
    assert_selector "h1", text: "LOG IN"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log In"
    assert_current_path root_path
  end
end
