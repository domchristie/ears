class EntriesController < ApplicationController
  def show
    @show = Show.call(self)
  end
end
