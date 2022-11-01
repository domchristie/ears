require "test_helper"

WebMock.disable_net_connect!(allow_localhost: true, allow: lambda { |uri|
  uri.host.include?("chromedriver.storage.googleapis.com")
})

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionMailer::TestHelper
  include EmailSpec::Helpers
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def login(user, password: "password")
    visit root_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Log In"
    assert_current_path root_path
  end
end
