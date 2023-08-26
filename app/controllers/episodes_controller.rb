class EpisodesController < ApplicationController
  before_action :authenticate

  def index
    @index = EpisodesController::Index.call(self)
  end
end
