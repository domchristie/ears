require "application_system_test_case"

class OpmlImportsTest < ApplicationSystemTestCase
  test "importing an OPML" do
    user = users(:one)
    login user
    click_link "Settings"
    click_link "Import OPML"
    attach_file "Choose OPML file", file_fixture("valid.opml")
    click_button "Import"
    assert_text "Import in progess"
    refresh
    assert_selector "article p a", text: "Radiolab"
    assert_selector "article p a", text: "99% Invisible"
  end
end
