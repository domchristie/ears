class ApplicationController < ActionController::Base
  before_action do
    Current.user = User.first
    Current.play = Play.most_recent_by(Current.user)
    Current.entry = Current.play.try(:entry)
  end
end
