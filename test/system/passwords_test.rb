require "application_system_test_case"

class PasswordsTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_as(users(:one))
  end

  test "updating the password" do
    click_on "Menu"
    click_on "Change Password"

    fill_in "Current password", with: "Secret1*3*5*"
    fill_in "New password", with: "Secret6*4*2*"
    fill_in "Confirm new password", with: "Secret6*4*2*"
    click_on "Update Password"

    assert_text "Password updated"
  end
end
