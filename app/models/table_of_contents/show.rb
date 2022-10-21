class TableOfContents::Show
  def initialize(params)
    @params = params
  end

  def start
    if table_of_contents.new_record?
      SyncTableOfContentsJob.perform_now(table_of_contents, source: :table_of_contents_show)
      table_of_contents.reload
    end
  end

  def entry
    @entry ||= find_entry
  end

  def table_of_contents
    @table_of_contents ||= find_table_of_contents
  end

  def chapters
    @chapters ||= table_of_contents
      .chapters
      .order(start_time: :asc)
  end

  def play
    @play ||= entry.play_by(Current.user)
  end

  private

  def find_entry
    Entry.find_by_hashid!(@params[:entry_id])
  end

  def find_table_of_contents
    entry.table_of_contents || entry.build_table_of_contents
  end
end
