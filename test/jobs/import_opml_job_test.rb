require "test_helper"

class ImportOpmlJobTest < ActiveJob::TestCase
  setup do
    @user = users(:one)
    @opml_import = opml_imports(:valid)
  end

  test "#perform creates feeds if they don't exist" do
    assert_difference "Feed.count", 2 do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end

    assert_no_difference "Feed.count" do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end
  end

  test "#perform creates followings if they don't exist" do
    assert_difference "Following.count", 2 do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end

    assert_no_difference "Following.count" do
      ImportOpmlJob.perform_now(@opml_import, @user)
    end
  end
end
