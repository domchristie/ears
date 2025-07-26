require "application_system_test_case"

class OpmlImportsTest < ApplicationSystemTestCase
  test "importing an OPML" do
    rss_fixture = Rails.root.join("test", "fixtures", "files", "feed.xml")

    stub_request(:get, "http://feeds.wnyc.org/radiolab")
      .to_return(status: 200, body: File.read(rss_fixture))
    stub_request(:get, "https://feeds.simplecast.com/BqbsxVfO")
      .to_return(status: 200, body: File.read(rss_fixture))

    user = users.one
    sign_in_as user
    click_link "Menu"
    click_link "Import OPML"
    attach_file "Choose OPML file", file_fixture("valid.opml")
    click_button "Import"
    assert_text "Import in progess"
    assert_difference -> { Following.count }, 2 do
      perform_enqueued_jobs
    end
    refresh
    assert_selector "article p", text: "All About Everything"
  end
end
