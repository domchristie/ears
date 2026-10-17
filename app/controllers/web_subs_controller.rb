class WebSubsController < ApplicationController
  allow_unauthenticated_access

  rescue_from "ActiveRecord::RecordNotFound" do
    head :not_found
  end

  def update
    if params[:"hub.mode"] == "subscribe"
      verify
    else
      head :not_found
    end
  end

  private

  def verify
    web_sub = WebSub.find(params[:id])

    if web_sub.verify_topic(params[:"hub.topic"])
      web_sub.confirm!(params[:"hub.lease_seconds"].to_i)
      render plain: params[:"hub.challenge"], status: :ok
    else
      head :not_found
    end
  end
end
