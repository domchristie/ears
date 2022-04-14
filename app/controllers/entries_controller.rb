class EntriesController < ApplicationController
  def show
    @entry = Entry.find(params[:id])
  end
end
