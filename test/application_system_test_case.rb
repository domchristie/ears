require "test_helper"

WebMock.disable_net_connect!(allow: lambda { |uri|
  uri.host.include?("chromedriver.storage.googleapis.com")
})

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def login(user)
    visit root_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Sign In"
    assert_current_path root_path
  end
end
