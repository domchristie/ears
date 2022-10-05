class Entries::TableOfContentsController < ApplicationController
  def show
    @toc_show = TableOfContents::Show.new(params)
    @toc_show.start
  end
end
