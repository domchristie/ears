class EntriesController < ApplicationController
  def show
    @entry = Entry.find_by_hashid!(params[:id])
  end
end
