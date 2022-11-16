require "test_helper"

WebMock.disable_net_connect!(allow_localhost: true, allow: lambda { |uri|
  uri.host.include?("chromedriver.storage.googleapis.com")
})

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionMailer::TestHelper
  include EmailSpec::Helpers
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in_as(user)
    visit sign_in_url
    fill_in :email, with: user.email
    fill_in :password, with: "Secret1*3*5*"
    click_on "Sign In"

    assert_current_path root_url
    user
  end
end
