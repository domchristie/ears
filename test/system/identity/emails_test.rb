require "application_system_test_case"

class Identity::EmailsTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_as users.one
  end

  test "changing an email address" do
    click_on "Menu"
    click_on "Change Email"
    fill_in "New email", with: "new@example.com"
    click_on "Update Email"
    assert_text "Email updated"

    perform_enqueued_jobs
    open_last_email
    click_first_link_in_email

    assert_text "Email confirmed"
    assert_current_path root_path
  end

  test "resending a verification email" do
    @user.update! verified: false
    click_on "Menu"
    click_on "Re-send verification email"
    assert_text "Email verification sent"

    perform_enqueued_jobs
    open_last_email
    click_first_link_in_email

    assert_text "Email confirmed"
    assert_current_path root_path
  end
end
