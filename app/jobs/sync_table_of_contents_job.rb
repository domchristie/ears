class SyncTableOfContentsJob < ApplicationJob
  queue_as :default

  def perform(table_of_contents, source:, force: false)
    puts "[#{self.class}] starting; table_of_contents: #{table_of_contents.id}, source: #{source}, force: #{force}"

    get = TableOfContents::Manager.fetch(table_of_contents, force: force)

    case get.response
    when Net::HTTPSuccess
      table_of_contents.update!(
        last_modified_at: get.headers["last-modified"],
        etag: get.headers["etag"]
      )

      ImportTableOfContentsJob.perform_now(
        table_of_contents,
        remote_table_of_contents: TableOfContents::Manager.parse(get.body),
        source: source
      )
      nil
    when Net::HTTPNotModified
      puts "[#{self.class}] table_of_contents: #{table_of_contents.id} Net::HTTPNotModified"
    when Net::HTTPTemporaryRedirect, Net::HTTPMovedPermanently
      puts "[#{self.class}] table_of_contents: #{table_of_contents.id} #{get.response.class}"
      # TODO: update Entry#podcast_chapters_url
    when Net::HTTPClientError
      puts "[#{self.class}] table_of_contents: #{table_of_contents.id} #{get.response.class}"
      # TODO: mark as gone?
    end
  end
end
