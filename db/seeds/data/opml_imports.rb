import = opml_imports.create :valid
import.file.attach io: Rails.root.join("test/fixtures/files/valid.opml").open, filename: "valid.opml", service_name: :test_fixtures
