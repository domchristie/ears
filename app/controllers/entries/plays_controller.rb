class Entries::PlaysController < ApplicationController
  def create
    entry = Entry.find(params[:entry_id])
    @play = entry.plays.first || entry.plays.build(feed: entry.feed)
    @play.update!(play_params)
    render partial: "plays/form", locals: {entry: entry, play: @play}
  end

  def update
    @play = Play.find(params[:id])
    @play.update!(play_params)
    render partial: "plays/form", locals: {entry: @play.entry, play: @play}
  end

  private

  def play_params
    params.require(:play).permit(:elapsed, :remaining)
  end
end
