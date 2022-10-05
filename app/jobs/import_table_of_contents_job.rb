class ImportTableOfContentsJob < ApplicationJob
  queue_as :default

  def perform(table_of_contents, remote_table_of_contents:, source:)
    puts "[#{self.class}] starting; table_of_contents: #{table_of_contents.id}, source: #{source}"

    attributes = TableOfContents.attributes_for_import(remote_table_of_contents)
    table_of_contents.update!(attributes)

    table_of_contents.chapters.destroy_all # Remove any old/out-of-date chapters
    Chapter.import_all!(table_of_contents.id, remote_table_of_contents[:chapters])
  end
end
