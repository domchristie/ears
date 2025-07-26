require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users.one
  end

  test "should get new" do
    get sign_in_url
    assert_response :success
  end

  test "should sign in" do
    post sign_in_url, params: {email: @user.email, password: "Secret1*3*5*"}
    assert_enqueued_email_with SessionMailer, :signed_in_notification, params: {session: @user.sessions.last}

    assert_redirected_to root_url

    get root_url
    assert_response :success
  end

  test "should not sign in with wrong credentials" do
    post sign_in_url, params: {email: @user.email, password: "SecretWrong1*3"}
    assert_redirected_to sign_in_url(email_hint: @user.email)
    assert_equal "Incorrect email or password", flash[:alert]

    get root_url
    assert_redirected_to sign_in_url
  end

  test "should sign out" do
    sign_in_as @user

    delete session_url(@user.sessions.last)

    assert_redirected_to sign_in_url
  end

  test "should redirect to root when already logged in" do
    sign_in_as @user

    get sign_in_url

    assert_redirected_to root_url
  end
end
