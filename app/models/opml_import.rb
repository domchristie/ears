class OpmlImport < ApplicationRecord
  has_one_attached :file

  def temp_file
    temp_file = Tempfile.new("opml_import_#{id}")
    file.open { |file| IO.copy_stream(file, temp_file) }
    temp_file.rewind
    temp_file
  end
end
