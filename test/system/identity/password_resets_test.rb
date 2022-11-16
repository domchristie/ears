require "application_system_test_case"

class Identity::PasswordResetsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @sid = @user.password_reset_tokens.create.signed_id(expires_in: 20.minutes)
  end

  test "password reset" do
    visit sign_in_url
    click_on "Forgot password?"
    assert_selector "h1", text: "FORGOT PASSWORD?"
    fill_in "Email", with: @user.email
    click_on "Send Instructions"
    assert_text "Check your email for instructions"

    perform_enqueued_jobs
    open_last_email

    click_first_link_in_email
    assert_selector "h1", text: "RESET YOUR PASSWORD"
    fill_in "New password", with: "Secret6*4*2*"
    fill_in "Confirm new password", with: "Secret6*4*2*"
    click_button "Update Password"
    assert_text "Password updated"
    assert_current_path root_path
  end
end
