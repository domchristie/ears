class Entries::PlayersController < ApplicationController
  def show
    @entry = Entry.find(params[:entry_id])
  end
end
