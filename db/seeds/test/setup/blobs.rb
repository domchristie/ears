def blob_for(name)
  path = file_fixture(name)
  { io: path.open, filename: path.to_s, service_name: :test_fixtures }
end
