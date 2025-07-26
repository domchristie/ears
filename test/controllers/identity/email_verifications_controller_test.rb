require "test_helper"

class Identity::EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as users.one
    @user.update! verified: false
  end

  test "requesting verification" do
    assert_enqueued_email_with UserMailer, :email_verification, params: {user: @user} do
      post identity_email_verification_url
    end

    assert_redirected_to root_url
  end

  test "verification with a valid token" do
    sid = @user.email_verification_tokens.create.signed_id(
      expires_in: EmailVerificationToken::VALIDITY_DURATION
    )

    get edit_identity_email_verification_url(sid: sid, email: @user.email)

    assert @user.reload.verified?
    assert_redirected_to root_url
  end

  test "attemping verification with an outdated token" do
    sid = @user.email_verification_tokens.create.signed_id(
      expires_in: EmailVerificationToken::VALIDITY_DURATION
    )

    travel EmailVerificationToken::VALIDITY_DURATION + 1 do
      get edit_identity_email_verification_url(sid: sid, email: @user.email)
    end

    refute @user.reload.verified?
    assert_redirected_to edit_identity_email_url
    assert_equal "Invalid verification link", flash[:alert]
  end
end
