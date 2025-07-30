require "test_helper"

class Identity::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as users.one
  end

  test "starting an email update" do
    get edit_identity_email_url
    assert_response :success
  end

  test "updating email" do
    assert @user.verified?

    patch identity_email_url, params: {email: "new-email@example.com"}

    refute @user.reload.verified?, "verification required after email update"
    assert_redirected_to root_url
  end
end
