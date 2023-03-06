class FeedsController < ApplicationController
  etag { current_user&.id }

  def show
    @show = FeedsController::Show.call(self)
    fresh_when(@show.feed, last_modified: @show.last_modified)
  end
end
