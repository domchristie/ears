class Directories::SearchesController < ApplicationController
  def new
    @search = Itunes::Search.new
  end

  def show
    @search = Itunes::Search.new(params[:term])
    @search.start
  end
end
