require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "starting registration" do
    get sign_up_url
    assert_response :success
  end

  test "successful registration" do
    assert_difference -> { User.count } do
      post sign_up_url, params: {email: "new-registration@example.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*"}
    end

    assert_redirected_to root_url
  end

  test "unsuccessful registration" do
    assert_no_difference -> { User.count } do
      post sign_up_url, params: {email: "new-registrationexample.com", password: "S", password_confirmation: ""}
    end

    assert_response :unprocessable_entity
  end
end
