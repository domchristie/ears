require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "lowercasing email addresses" do
    user = User.create!(email: "DEMO@EXAMPLE.COM", password: "helloWorld123")
    assert_equal "demo@example.com", user.email
  end
end
