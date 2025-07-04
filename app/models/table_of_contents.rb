class TableOfContents < ApplicationRecord
  belongs_to :entry
  has_many :chapters, dependent: :destroy

  def url
    entry.podcast_chapters_url
  end

  def uri
    URI(url)
  end

  def sync(source)
    SyncTableOfContentsJob.perform_now(self, source:)
    reload
  end

  def self.attributes_for_import(remote_table_of_contents)
    {
      version: remote_table_of_contents[:version],
      author: remote_table_of_contents[:author],
      title: remote_table_of_contents[:title],
      podcast_name: remote_table_of_contents[:podcastName],
      description: remote_table_of_contents[:description],
      file_name: remote_table_of_contents[:fileName],
      waypoints: remote_table_of_contents[:waypoints]
    }
  end

  def self.parse(rss)
    JSON.parse(rss, symbolize_names: true)
  end

  def self.fetch(table_of_contents, force: false)
    headers = unless force
      {
        "If-Modified-Since": table_of_contents.last_modified_at.try(:to_fs, :rfc7231),
        "If-None-Match": table_of_contents.etag
      }
    end

    Http::Navigation.start(Net::HTTP::Get.new(table_of_contents.uri, headers))
  end
end
