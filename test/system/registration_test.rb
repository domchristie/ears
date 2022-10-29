require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  test "signing up" do
    visit signup_path
    assert_selector "h1", text: "SIGN UP"
    fill_in "Email", with: "new@example.com"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    click_button "Sign Up"
    assert_current_path root_path
    open_last_email
    click_first_link_in_email
    assert_text "Your account has been confirmed."
    assert_current_path root_path
  end
end
