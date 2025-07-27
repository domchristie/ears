require "test_helper"

class ImportOpmlJobTest < ActiveJob::TestCase
  setup do
    @user = users.one
    @opml_import = opml_imports.create file: blob_for("valid.opml")

    body = file_fixture("feed.xml").read
    stub_request(:get, "http://feeds.wnyc.org/radiolab").to_return(status: 200, body:)
    stub_request(:get, "https://feeds.simplecast.com/BqbsxVfO").to_return(status: 200, body:)
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
