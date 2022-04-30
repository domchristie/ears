require "test_helper"

class Entries::PlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get entries_players_show_url
    assert_response :success
  end
end
