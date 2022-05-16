class WebSubs::FeedsController < ApplicationController
  class InvalidSignature < StandardError
    def initialize(message, context)
      @context = context
      super(message)
    end

    def to_honeybadger_context
      @context
    end
  end

  skip_forgery_protection only: :update

  def update
    subscription = WebSub.find(params[:web_sub_id])
    algorithm, signature = parse_signature_header

    if subscription.validate_signature(algorithm, signature, request.raw_post)
      SyncFeedJob.perform_later(subscription.feed, source: :web_sub)
    else
      raise InvalidSignature.new(
        "InvalidSignature",
        algorithm: algorithm, signature: signature, body: body
      )
    end

    head :ok
  end

  private

  def parse_signature_header
    request.headers["X-Hub-Signature"].split("=")
  end
end
