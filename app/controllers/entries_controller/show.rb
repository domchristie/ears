class EntriesController::Show < ControllerAction
  def entry
    @entry ||= Entry.find_by_hashid!(params[:id])
  end

  def feed
    @feed ||= entry.feed
  end

  def show_notes
    @show_notes ||= ShowNotes.new(entry)
  end
end
