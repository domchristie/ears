class WebSubsController < ApplicationController
  allow_unauthenticated_access

  rescue_from "ActiveRecord::RecordNotFound" do
    head :not_found
  end

  def update
    verify if params[:"hub.mode"].in?(["subscribe", "unsubscribe"])
  end

  private

  def verify
    subscription = find_subscription

    if subscription.verify_topic(params[:"hub.topic"])
      ConfirmWebSubJob.perform_now(
        subscription,
        lease_seconds: params[:"hub.lease_seconds"].to_i
      )
      render plain: params[:"hub.challenge"], status: :ok
    else
      head :not_found
    end
  end

  def find_subscription
    WebSub.find(params[:id])
  end
end
