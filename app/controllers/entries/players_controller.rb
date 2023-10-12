class Entries::PlayersController < ApplicationController
  def show
    @entry = Entry.find_by_hashid!(params[:entry_id])

    if turbo_frame_request?
      request.variant << :turbo_frame
    else
      render layout: "base"
    end
  end
end
