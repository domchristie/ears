require "test_helper"

class Users::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get users_dashboards_show_url
    assert_response :success
  end
end
