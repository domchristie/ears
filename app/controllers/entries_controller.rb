class EntriesController < ApplicationController
  def show
    @show = EntriesController::Show.call(self)
  end
end
