class TableOfContents < ApplicationRecord
  belongs_to :entry

  def url
    entry.podcast_chapters_url
  end
end
