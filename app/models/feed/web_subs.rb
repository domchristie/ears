module Feed::WebSubs
  extend ActiveSupport::Concern

  # Hubs do not always deliver notifications, so feeds with an active WebSub
  # are still polled, but less often
  WEB_SUB_POLL_INTERVAL = 6.hours

  included do
    has_many :web_subs, foreign_key: :feed_url, primary_key: :url, dependent: :destroy

    scope :web_subable, -> { Feed.where.not(web_sub_hub_url: nil) }

    scope :with_active_web_sub, -> {
      where(url: WebSub.where(expires_at: Time.current..).select(:feed_url))
    }

    scope :imported_since, ->(time) {
      where(id: Import.where(resource_type: "Feed", finished_at: time..).select(:resource_id))
    }

    scope :sync_due, -> {
      where.not(id: with_active_web_sub.imported_since(WEB_SUB_POLL_INTERVAL.ago).select(:id))
    }

    scope :web_sub_renewal_due, -> {
      web_subable.where.not(url: WebSub.renewal_not_due.select(:feed_url))
    }

    before_save if: -> { will_save_change_to_url? || will_save_change_to_web_sub_hub_url? || will_save_change_to_web_sub_topic_url? } do
      WebSub.where(feed_url: url_in_database).destroy_all
    end

    after_commit :start_web_sub, if: -> {
      web_sub_attributes_changed? && web_subable?
    }
  end

  class_methods do
    def renew_web_subs
      web_sub_renewal_due.find_each(&:start_web_sub)
    end
  end

  def web_subable?
    web_sub_hub_url.present?
  end

  def web_sub_attributes_changed?
    saved_change_to_web_sub_hub_url? || saved_change_to_url? || saved_change_to_web_sub_topic_url?
  end

  def web_sub_topic
    web_sub_topic_url || url
  end

  def start_web_sub
    web_subs.start_later!(hub_url: web_sub_hub_url)
  end
end
