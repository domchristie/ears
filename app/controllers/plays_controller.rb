class PlaysController < ApplicationController
  before_action :authenticate

  def index
    @index = PlaysController::Index.call(self)
  end
end
