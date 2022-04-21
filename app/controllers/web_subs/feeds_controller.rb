class WebSubs::FeedsController < ApplicationController
  def update
    subscription = WebSub.find(params[:web_sub_id])

    if subscription.validate_signature(*parse_signature_header)
      ImportFeedJob.perform_later(
        subscription.feed,
        rss: request.body,
        source: :web_sub,
        at: Time.now.utc
      )
    end

    head :ok
  end

  private

  def parse_signature_header
    request.headers["X-Hub-Signature"].split("=")
  end
end
