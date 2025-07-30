require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as users.one
  end

  test "starting a password change" do
    get edit_password_url
    assert_response :success
  end

  test "updating a password with valid credentials" do
    old_password_digest = @user.password_digest

    patch password_url, params: {current_password: "Secret1*3*5*", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*"}

    assert_not_equal old_password_digest, @user.reload.password_digest
    assert_redirected_to root_url
    assert_equal "Password updated", flash[:notice]
  end

  test "attempting a password update with invalid credentials" do
    password_digest = @user.password_digest

    patch password_url, params: {current_password: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*"}

    assert_equal password_digest, @user.reload.password_digest
    assert_redirected_to edit_password_url
    assert_equal "Incorrect password", flash[:alert]
  end
end
