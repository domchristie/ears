require "test_helper"

class Identity::PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users.one
  end

  test "starting a password reset" do
    get new_identity_password_reset_url
    assert_response :success
  end

  test "requesting a password reset" do
    assert_enqueued_email_with UserMailer, :password_reset, params: {user: @user} do
      post identity_password_reset_url, params: {email: @user.email}
    end

    assert_redirected_to sign_in_url
  end

  test "requesting a password reset with an non-existent email" do
    assert_no_enqueued_emails do
      post identity_password_reset_url, params: {email: "non-existent@example.com"}
    end

    assert_redirected_to new_identity_password_reset_url
    assert_equal "Email verification required", flash[:alert]
  end

  test "requesting a password reset with an unverified email" do
    @user.update! verified: false

    assert_no_enqueued_emails do
      post identity_password_reset_url, params: {email: @user.email}
    end

    assert_redirected_to new_identity_password_reset_url
    assert_equal "Email verification required", flash[:alert]
  end

  test "starting a password reset with a valid token" do
    sid = @user.password_reset_tokens.create.signed_id(
      expires_in: PasswordResetToken::VALIDITY_DURATION
    )

    get edit_identity_password_reset_url(sid: sid)

    assert_response :success
  end

  test "resetting a password with a valid token" do
    sid = @user.password_reset_tokens.create.signed_id(
      expires_in: PasswordResetToken::VALIDITY_DURATION
    )
    old_password_digest = @user.password_digest

    patch identity_password_reset_url, params: {sid: sid, password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*"}

    assert_not_equal old_password_digest, @user.reload.password_digest
    assert_redirected_to root_url
  end

  test "attempting a reset with an expired token" do
    sid = @user.password_reset_tokens.create.signed_id(
      expires_in: PasswordResetToken::VALIDITY_DURATION
    )
    password_digest = @user.password_digest

    travel PasswordResetToken::VALIDITY_DURATION + 1 do
      patch identity_password_reset_url, params: {sid: sid, password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*"}
    end

    assert_equal password_digest, @user.reload.password_digest
    assert_redirected_to new_identity_password_reset_url
    assert_equal "Invalid password reset link", flash[:alert]
  end
end
