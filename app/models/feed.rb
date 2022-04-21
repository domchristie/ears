class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_one :rss_image, as: :rss_imageable
  has_many :web_subs, foreign_key: :feed_url, primary_key: :url, dependent: :destroy

  after_commit :start_web_sub, if: :saved_change_to_web_sub_hub_url?

  def author
    itunes_author || managing_editor
  end

  def image_url
    rss_image.try(:url) || itunes_image
  end

  def self.attributes_for_import(remote_feed)
    {
      web_sub_hub_url: remote_feed.hubs.first,
      copyright: remote_feed.copyright,
      description: remote_feed.description,
      language: remote_feed.language,
      last_build_at: remote_feed.last_built,
      website_url: remote_feed.url,
      managing_editor: remote_feed.managing_editor,
      title: remote_feed.title,
      ttl: remote_feed.ttl,
      itunes_author: remote_feed.itunes_author,
      itunes_block: remote_feed.itunes_block == "Yes",
      itunes_image: remote_feed.itunes_image,
      itunes_explicit: remote_feed.itunes_explicit == "true",
      itunes_complete: remote_feed.itunes_complete == "Yes",
      itunes_keywords: remote_feed.itunes_keywords,
      itunes_type: remote_feed.itunes_type,
      itunes_new_feed_url: remote_feed.itunes_new_feed_url,
      itunes_subtitle: remote_feed.itunes_subtitle,
      itunes_summary: remote_feed.itunes_summary
    }
  end

  private

  def start_web_sub
    StartWebSubJob.perform_later(self)
  end
end
