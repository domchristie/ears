class ConfirmWebSubJob < ApplicationJob
  queue_as :default

  def perform(web_sub, lease_seconds:)
    web_sub.update!(expires_at: web_sub.created_at + lease_seconds)

    # renew early to prevent gaps
    RenewWebSubJob
      .set(wait_until: web_sub.expires_at - 6.hours)
      .perform_later(web_sub)

    WebSub
      .where(feed_url: web_sub.feed_url, hub_url: web_sub.hub_url)
      .where.not(id: web_sub.id)
      .delete_all
  end
end
