class Entries::TableOfContentsController < ApplicationController
  def show
    @show = TableOfContentsController::Show.call(self)
  end
end
