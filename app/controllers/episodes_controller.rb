class EpisodesController < ApplicationController
  def index
    @index = Index.call(self)
  end
end
