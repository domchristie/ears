class PlaysController < ApplicationController
  def index
    @index = Index.call(self)
  end
end
