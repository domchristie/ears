class ApplicationController < ActionController::Base
  include Authentication

  before_action :setup_player, if: :user_signed_in?

  private

  def setup_player
    Current.play = Play.most_recent_by(Current.user) || NilPlay.new
    Current.entry = Current.play.try(:entry)
  end
end
