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

  test "resetting password" do
    user = users(:one)
    visit login_path
    click_link "Forgot password?"
    assert_selector "h1", text: "FORGOT PASSWORD?"
    fill_in "Email", with: user.email
    click_button "Send Instructions"
    assert_text "If that user exists we've sent instructions to their email."
    open_last_email
    click_first_link_in_email
    assert_selector "h1", text: "ENTER A NEW PASSWORD"
    fill_in "New password", with: "newpassword"
    fill_in "Confirm new password", with: "newpassword"
    click_button "Update Password"
    assert_current_path root_path
    assert_text "Password updated"
  end
end
