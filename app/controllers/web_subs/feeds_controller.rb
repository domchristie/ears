class WebSubs::FeedsController < ApplicationController
  class InvalidSignature < StandardError; end

  skip_forgery_protection only: :update

  def update
    subscription = WebSub.find(params[:web_sub_id])

    if subscription.validate_signature(*parse_signature_header)
      SyncFeedJob.perform_later(subscription.feed, source: :web_sub)
    else
      raise InvalidSignature.new(request.headers["X-Hub-Signature"])
    end

    head :ok
  end

  private

  def parse_signature_header
    request.headers["X-Hub-Signature"].split("=")
  end
end
