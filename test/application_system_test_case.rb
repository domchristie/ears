require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  setup do
    WebMock.allow_net_connect!
  end

  def login(user)
    visit root_path
    fill_in "Email", with: user.email
    click_button "Sign In"
    assert_current_path root_path
  end
end
