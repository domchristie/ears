class FeedsController < ApplicationController
  def index
    @feeds = Feed.all.order(title: :asc)
  end
end
