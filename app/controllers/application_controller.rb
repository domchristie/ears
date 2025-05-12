class ApplicationController < ActionController::Base
  include Authentication

  before_action :set_variant
  before_action :current_user
  before_action :setup_player

  helper_method def current_user
    Current.user
  end

  helper_method :turbo_native_app?

  VARIANTS = [:list_items]

  def blank
    render layout: "blank"
  end

  helper_method def turbo_request?
    request.headers.include? "Turbo-Request"
  end

  private

  def set_variant
    request.variant << params[:variant].to_sym if params[:variant].in?(VARIANTS)
  end

  def setup_player
    Current.play = Play.most_recent_by(Current.user) || NilPlay.new
    Current.entry = Current.play.try(:entry) || NilEntry.new
  end
end
