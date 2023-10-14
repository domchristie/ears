class ApplicationController < ActionController::Base
  before_action :set_variant
  before_action :current_user
  before_action :set_current_request_details
  before_action :setup_player

  helper_method def current_user
    Current.user ||= Session.find_by(id: cookies.signed[:session_token])&.user
  end

  helper_method :turbo_native_app?

  VARIANTS = [:list_items]

  def blank
    render layout: "blank"
  end

  helper_method def fetch_request?
    request.xhr? || request.headers["sec-fetch-mode"] != "navigate"
  end

  private

  def set_variant
    request.variant << params[:variant].to_sym if params[:variant].in?(VARIANTS)
  end

  def authenticate
    if (session = Session.find_by_id(cookies.signed[:session_token]))
      Current.session = session
    else
      redirect_to sign_in_path
    end
  end

  def sign_in(user)
    session = user.sessions.create!
    cookies.signed.permanent[:session_token] = {value: session.id, httponly: true}
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def setup_player
    Current.play = Play.most_recent_by(Current.user) || NilPlay.new
    Current.entry = Current.play.try(:entry) || NilEntry.new
  end
end
