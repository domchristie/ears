class EpisodesController < ApplicationController
  before_action :authenticate

  def index
    @index = Index.call(self)
  end
end
