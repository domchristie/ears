class Entries::PlaysController < ApplicationController
  def create
    entry = Entry.find_by_hashid!(params[:entry_id])
    @play = Current.user.plays.find_or_initialize_by(
      entry: entry,
      feed: entry.feed
    )
    @play.update!(play_params)
    head :ok
  end

  private

  def play_params
    params.require(:play).permit(:elapsed, :remaining)
  end
end
