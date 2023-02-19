class FeedsController < ApplicationController
  etag { current_user&.id }

  def show
    @show = FeedsController::Show.call(self)

    fresh_when(
      @show.feed,
      last_modified: [
        @show.feed.updated_at,
        @show.most_recent_entry.published_at,
        @show.most_recent_play&.updated_at
      ].compact.max
    )
  end
end
