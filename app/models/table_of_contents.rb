class TableOfContents < ApplicationRecord
  belongs_to :entry

  def url
    entry.podcast_chapters_url
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
end
