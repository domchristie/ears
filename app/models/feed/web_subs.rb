module Feed::WebSubs
  extend ActiveSupport::Concern

  included do
    has_many :web_subs, foreign_key: :feed_url, primary_key: :url, dependent: :destroy
    has_many :active_web_subs, -> { where("active_web_subs.expires_at > ?", Time.current) }, class_name: "WebSub", foreign_key: :feed_url, primary_key: :url

    scope :web_subable, -> { Feed.where.not(web_sub_hub_url: nil) }

    before_save if: :will_save_change_to_url? do
      WebSub.where(feed_url: url_in_database).destroy_all
    end

    after_commit :start_web_sub, if: -> {
      web_sub_attributes_changed? && web_subable?
    }
  end

  def web_subable?
    web_sub_hub_url.present?
  end

  def web_sub_attributes_changed?
    saved_change_to_web_sub_hub_url? || saved_change_to_url?
  end

  def start_web_sub
    StartWebSubJob.perform_later(self)
  end
end
