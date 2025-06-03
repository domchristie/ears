class Entries::TableOfContentsController < ApplicationController
  def show
    @entry = find_entry
    @table_of_contents = find_table_of_contents

    if @table_of_contents.new_record?
      @table_of_contents.sync(:table_of_contents_show)
    end

    @chapters = @table_of_contents.chapters.ordered
    @play = @entry.play_by(Current.user)
  end

  private

  def find_entry
    Entry.find_by_hashid!(params[:entry_id])
  end

  def find_table_of_contents
    @entry.table_of_contents || @entry.build_table_of_contents
  end
end
