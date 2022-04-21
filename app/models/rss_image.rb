class RssImage < ApplicationRecord
  belongs_to :rss_imageable, polymorphic: true

  def self.import!(type, id, remote_image)
    attributes = RssImage.attributes_for_import(remote_image).merge(
      rss_imageable_type: type,
      rss_imageable_id: id
    )

    upsert(
      attributes,
      unique_by: [:rss_imageable_type, :rss_imageable_id],
      record_timestamps: true
    )
  end

  def self.attributes_for_import(remote_image)
    {
      url: remote_image.url,
      description: remote_image.description,
      title: remote_image.title,
      width: remote_image.width,
      height: remote_image.height,
      website_url: remote_image.link
    }
  end
end
