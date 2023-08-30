class Queues::ItemsController < ApplicationController
  def create
    @queue_item = current_user.queue.prepend_entry(
      Entry.find(params[:playlist_item][:entry_id])
    )
    redirect_back_or_to queue_path
  end

  def destroy
    @queue_item = current_user.queue.remove_entry(
      Entry.find_by_hashid(params[:entry_id])
    )
    redirect_back_or_to queue_path
  end
end
