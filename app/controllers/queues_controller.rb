class QueuesController < ApplicationController
  def show
    @show = QueuesController::Show.call(self)
  end
end
