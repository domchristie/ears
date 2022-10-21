class Entries::PlayersController < ApplicationController
  def show
    @entry = Entry.find_by_hashid!(params[:entry_id])
  end
end
