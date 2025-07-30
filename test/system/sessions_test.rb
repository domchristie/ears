require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  setup do
    @user = users.one
  end

  test "signing in" do
    visit sign_in_url
    fill_in "Email", with: @user.email
    fill_in "Password", with: "Secret1*3*5*"
    click_on "Sign In"
    assert_current_path root_path
  end

  test "signing out" do
    sign_in_as @user
    click_on "Menu"
    click_on "Log Out"
    assert_text "Signed out"
  end
end
