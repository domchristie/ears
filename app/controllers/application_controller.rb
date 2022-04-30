class ApplicationController < ActionController::Base
  before_action do
    Current.play = Play.most_recent
    Current.entry = Current.play.try(:entry)
  end
end
