class ImportOpmlJob < ApplicationJob
  queue_as :default

  def perform(opml_import)
    doc = Nokogiri::XML.parse(opml_import.temp_file)
    attributes = doc.css("outline").map do |outline|
      {
        url: outline.attr("xmlUrl"),
        title: outline.attr("title").presence || outline.attr("text")
      }
    end
    Feed.insert_all!(attributes)
    opml_import.destroy!
  end
end
