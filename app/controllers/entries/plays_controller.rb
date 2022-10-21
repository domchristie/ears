class Entries::PlaysController < ApplicationController
  def create
    entry = Entry.find_by_hashid!(params[:entry_id])
    @play = Current.user.plays.find_or_initialize_by(
      entry: entry,
      feed: entry.feed
    )
    @play.update!(play_params)
    render partial: "plays/form", locals: {entry: entry, play: @play}
  end

  def update
    @play = Play.find(params[:id])
    return head(:forbidden) unless Current.user == @play.user

    @play.update!(play_params)
    render partial: "plays/form", locals: {entry: @play.entry, play: @play}
  end

  private

  def play_params
    params.require(:play).permit(:elapsed, :remaining)
  end
end
