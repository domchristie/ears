require "application_system_test_case"

class AccountAdministrationTest < ApplicationSystemTestCase
  test "user registration" do
    visit signup_path
    assert_selector "h1", text: "SIGN UP"
    fill_in "Email", with: "new@example.com"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    click_button "Sign Up"
    assert_current_path root_path
    open_last_email
    click_first_link_in_email
    assert_text "Your account has been confirmed"
    assert_current_path root_path
  end

  test "updating email" do
    login users(:one)
    click_link "Settings"
    click_link "Account"
    fill_in "New email", with: "new@example.com"
    fill_in "Current password", with: "password"
    click_button "Update Account"
    assert_text "Check your email for confirmation instructions"
    assert_current_path account_path
    open_last_email
    click_first_link_in_email
    assert_text "Your account has been confirmed"
    assert_current_path root_path
  end

  test "updating password" do
    login users(:one)
    click_link "Settings"
    click_link "Account"
    fill_in "Password", id: "user_password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    fill_in "Current password", with: "password"
    click_button "Update Account"
    assert_text "Account updated"
    assert_current_path account_path
  end

  test "user deletion" do
    login users(:one)
    click_link "Settings"
    click_link "Account"
    click_button "Delete Account"
    assert_current_path login_path
    assert_text "Account deleted"
  end
end
