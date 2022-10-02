class TableOfContents::Manager
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

    HTTParty.get(table_of_contents.url, headers: headers)
  end
end
